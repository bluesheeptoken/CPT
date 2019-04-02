# distutils: language = c++

from libcpp.vector cimport vector
from libcpp.queue cimport queue
from libcpp.iterator cimport back_inserter
from cython.parallel import prange
from cpython.object cimport Py_EQ, Py_NE

from cpt.prediction_tree cimport PredictionTree, Node, ROOT
from cpt.alphabet cimport Alphabet
from cpt.alphabet cimport NOT_AN_INDEX
from cpt.scorer cimport Scorer
from cpt.bitset cimport Bitset

cdef extern from "<algorithm>" namespace "std" nogil:
    InputIt find[InputIt](InputIt first, InputIt last, int val)
    InputIt remove[InputIt](InputIt first, InputIt last, int val)
    OutputIt remove_copy[InputIt, OutputIt](InputIt first, InputIt second, OutputIt third, int val)

cdef class Cpt:
    # Only python accessible attributes are documented
    '''
    Compact Prediction Tree class.

    Attributes
    ----------
    split_length : int, default 0 (all elements are considered)
        The split length is used to delimit the length of training sequences.
    noise_ratio : float, default 0 (no noise)
        The threshold of frequency to consider elements as noise.
    MBR : int, default 0 (at least one update)
        Minimum number of similar sequences needed to compute predictions.
    alphabet : Alphabet
        The alphabet is used to encode values for Cpt. ``alphabet`` should not be used directly.
    '''
    def __init__(self, int split_length=0, float noise_ratio=0, int MBR=0):
        if split_length < 0:
            raise ValueError('split_length value should be non-negative, actual value: {}'.format(split_length))
        _check_noise_ratio(noise_ratio)
        _check_MBR(MBR)
        self.tree = PredictionTree()
        self.inverted_index = vector[Bitset]()
        self.lookup_table = vector[Node]()
        self.split_length = -split_length
        self.noise_ratio = noise_ratio
        self.MBR = MBR
        self.alphabet = Alphabet()
        self._number_trained_sequences = 0

    def fit(self, sequences):
        '''Train the model with a list of sequence.

        The model can be retrained to add new sequences.
        ``model.fit(seq1);model.fit(seq2)`` is equivalent to
        ``model.fit(seq1 + seq2)`` with seq1, seq2 list of sequences.

        Parameters
        ----------
        sequences : list
            A list of sequences of any hashable type.

        Returns
        -------
        None

        Examples
        --------
        >>> model.fit([['hello', 'world'], ['hello', 'cpt']])
        '''
        cdef size_t number_sequences_to_train = len(sequences)
        cdef Node current

        # Resize bitsets if this is not the first time the model is training
        if self._number_trained_sequences != 0:
            for i in range(self.inverted_index.size()):
                self.inverted_index[i].resize(self._number_trained_sequences + number_sequences_to_train)

        for i, sequence in enumerate(sequences):
            id_seq = i + self._number_trained_sequences
            current = ROOT
            for index in map(self.alphabet.add_symbol,
                             sequence[self.split_length:]):

                # Adding to the Prediction Tree
                current = self.tree.addChild(current, index)

                # Adding to the Inverted Index
                if not index < self.inverted_index.size():
                    self.inverted_index.push_back(Bitset(self._number_trained_sequences + number_sequences_to_train))

                self.inverted_index[index].add(id_seq)

            # Add the last node in the lookup_table
            self.lookup_table.push_back(current)
        self._number_trained_sequences += number_sequences_to_train

    cpdef predict(self, list sequences, bint multithreading=True):
        '''Predict the next element of each sequence of the parameter ``sequences``.

        Parameters
        ----------
        sequences : list
            A list of sequences of any hashable type.
        multithreading : bool, default True
            True if the multithreading should be used for predictions.

        Raises
        ------
        ValueError
            noise_ratio should be between 0 and 1.
            MBR should be non-negative.

        Returns
        -------
        predictions : list of length ``len(sequences)``
            The predicted elements.

        Examples
        --------

        >>> model = Cpt()

        >>> model.fit([['hello', 'world'],
             ['hello', 'this', 'is', 'me'],
             ['hello', 'me']
            ])

        >>> model.predict([['hello'], ['hello', 'this']])
        ['me', 'is']
        '''
        cdef:
            vector[int] least_frequent_items, sequence_indexes
            vector[vector[int]] sequences_indexes
            Py_ssize_t i, j
            int len_sequences = len(sequences)
            vector[int] int_predictions

        _check_noise_ratio(self.noise_ratio)

        _check_MBR(self.MBR)

        least_frequent_items = self.c_compute_noisy_items(self.noise_ratio)

        if multithreading:
            int_predictions = vector[int](len_sequences)
            sequences_indexes = vector[vector[int]]()
            # Preparation of data
            for i in range(len_sequences):
                sequence = sequences[i]
                sequences_indexes.push_back(vector[int]())
                for j in range(len(sequence)):
                    sequences_indexes.back().push_back(self.alphabet.get_index(sequence[j]))

            # Predictions
            for i in prange(len_sequences, nogil=True, schedule='dynamic'):
                int_predictions[i] = self.predict_seq(sequences_indexes[i], least_frequent_items)

        else:
            for i in range(len_sequences):
                sequence = sequences[i]
                sequence_indexes = vector[int]()
                for j in range(len(sequence)):
                    sequence_indexes.push_back(self.alphabet.get_index(sequence[j]))
                int_predictions.push_back(self.predict_seq(sequence_indexes, least_frequent_items))

        return [self.alphabet.get_symbol(x) for x in int_predictions]

    def compute_noisy_items(self, noise_ratio):
        '''Compute noisy elements.

        An element is considered as noise if the frequency of sequences
        in which it appears at least once is below ``noise_ratio``.

        Parameters
        ----------
        noise_ratio : float
            The threshold of frequency to consider elements as noise.

        Raises
        ------
        ValueError
            noise_ratio should be between 0 and 1

        Returns
        -------
        noisy_items : list
            The noisy items.
        '''
        _check_noise_ratio(self.noise_ratio)
        return [self.alphabet.get_symbol(x) for x in <list>self.c_compute_noisy_items(noise_ratio)]

    def find_similar_sequences(self, sequence):
        '''Find similar sequences.

        A sequence similar ``X`` of a sequence ``S`` is a sequence
        in which every element of ``S`` is in ``X``

        Parameters
        ----------
        sequence : list

        Returns
        -------
        similar_sequences : list
            The list of similar_sequences.
        '''
        cdef vector[int] sequence_index = [self.alphabet.get_index(symbol) for symbol in sequence]
        similar_sequences_index = self.retrieve_similar_sequences(sequence_index)
        return [self.retrieve_sequence(index) for index in similar_sequences_index]

    def retrieve_sequence(self, index):
        '''Retrieve sequence from the training data.

        Parameters
        ----------
        index : int
            Index of the sequence to retrieve.

        Returns
        -------
        sequence : list

        Examples
        --------

        >>> model = Cpt()
        >>> model.fit([['sample', 'data'], ['should', 'not', 'be', 'retrieved']])
        >>> model.retrieve_sequence(0)
        ['sample', 'data']
        '''

        if index < 0:
            raise ValueError('index should be non-negative, actual value : {}'.format(index))

        sequence = []
        end_node = self.lookup_table[index]
        next_transition = self.tree.getTransition(end_node)

        while next_transition != NOT_AN_INDEX:
            sequence.append(next_transition)
            end_node = self.tree.getParent(end_node)
            next_transition = self.tree.getTransition(end_node)

        return [self.alphabet.get_symbol(index) for index in reversed(sequence)]

    cdef int predict_seq(self, vector[int] target_sequence, vector[int] least_frequent_items) nogil:
        cdef:
            Scorer scorer = Scorer(self.alphabet.length)
            queue[vector[int]] suffixes = queue[vector[int]]()
            vector[int] suffix_without_noise, suffix
            size_t i
            int noise, update_count = 0

        target_sequence.erase(remove(target_sequence.begin(), target_sequence.end(), NOT_AN_INDEX), target_sequence.end())

        suffixes.push(target_sequence)
        update_count += self.update_score(target_sequence, scorer)

        while update_count < self.MBR and not suffixes.empty():
            suffix = suffixes.front()
            suffixes.pop()
            for i in range(least_frequent_items.size()):
                noise = least_frequent_items[i]
                if find(suffix.begin(), suffix.end(), noise) != suffix.end():
                    suffix_without_noise.clear()
                    remove_copy(suffix.begin(), suffix.end(), back_inserter(suffix_without_noise), noise)
                    if not suffix_without_noise.empty():
                        suffixes.push(suffix_without_noise)
                        update_count += self.update_score(suffix_without_noise, scorer)

        return scorer.get_best_prediction()

    cdef vector[int] c_compute_noisy_items(self, float noise_ratio) nogil:
        cdef:
            int i
            vector[int] least_frequent_items = vector[int]()

        for i in range(self.alphabet.length):
            if self.inverted_index[i].compute_frequency() <= noise_ratio:
                least_frequent_items.push_back(i)

        return least_frequent_items

    cdef Bitset c_find_similar_sequences(self, vector[int] sequence) nogil:
        if sequence.empty():
            return Bitset(self.alphabet.length)

        cdef Bitset bitset_temp
        cdef size_t i

        bitset_temp = Bitset(self.inverted_index[sequence[0]])
        for i in range(1, sequence.size()):
            bitset_temp.inter(self.inverted_index[sequence[i]])

        return bitset_temp

    cdef int update_score(self, vector[int] suffix, Scorer& scorer) nogil:
        cdef:
            Bitset similar_sequences, bitseq = Bitset(self.alphabet.length)
            size_t i, similar_sequence_id
            Node end_node
            int next_transition, update_count = 0

        for i in range(suffix.size()):
            bitseq.add(suffix[i])
        similar_sequences = self.c_find_similar_sequences(suffix)

        for similar_sequence_id in range(similar_sequences.size()):
            if similar_sequences[similar_sequence_id]:
                end_node = self.lookup_table[similar_sequence_id]
                next_transition = self.tree.getTransition(end_node)
                update_count += not bitseq[next_transition]

                while not bitseq[next_transition]:
                    scorer.update(next_transition)
                    end_node = self.tree.getParent(end_node)
                    next_transition = self.tree.getTransition(end_node)

        return update_count

    cdef list retrieve_similar_sequences(self, vector[int] sequence_index):
        cdef Bitset bitset_similar = self.c_find_similar_sequences(sequence_index)
        return [index for index in range(bitset_similar.size()) if bitset_similar[index]]

    def _get_inverted_index(self):
        '''Should not be used in python'''
        return [(x.get_data(), x.size()) for x in self.inverted_index]

    def _get_prediction_tree(self):
        '''Should not be used in python'''
        return (self.tree.get_next_node(),
            self.tree.get_incoming(),
            self.tree.get_parent(),
            self.tree.get_children())

    def _get_lookup_table(self):
        '''Should not be used in python'''
        return <list>self.lookup_table

    def __getstate__(self):
        inverted_index_state = []

        for bitset in self.inverted_index:
            inverted_index_state.append((bitset.get_data(), bitset.size()))

        return (self.split_length,
                self.alphabet,
                self.lookup_table,
                inverted_index_state,
                (self.tree.get_next_node(),
                self.tree.get_incoming(),
                self.tree.get_parent(),
                self.tree.get_children()),
                self._number_trained_sequences)

    def __setstate__(self, state):
        split_length, alphabet, lookup_table_state, inverted_index_state, prediction_tree_state, number_trained_sequences = state
        self.split_length = split_length
        self.alphabet = alphabet
        self.lookup_table = lookup_table_state
        for bitset_state in inverted_index_state:
            self.inverted_index.push_back(Bitset(bitset_state[0], bitset_state[1]))
        self.tree = PredictionTree(prediction_tree_state[0], prediction_tree_state[1], prediction_tree_state[2], prediction_tree_state[3])
        self._number_trained_sequences = number_trained_sequences

    def __is_equal__(self, other):
        return self._get_prediction_tree() == other._get_prediction_tree() and \
               self._get_inverted_index() == other._get_inverted_index() and \
               self._get_lookup_table() == other._get_lookup_table() and \
               self.split_length == other.split_length and \
               self.alphabet == other.alphabet and \
               self._number_trained_sequences == other._number_trained_sequences

    def __richcmp__(self, other, op):
        if op == Py_EQ:
            return self.__is_equal__(other)
        elif op == Py_NE:
            return not self.__is_equal__(other)
        else:
            assert False

def _check_noise_ratio(noise_ratio):
    if not 0 <= noise_ratio <= 1:
        raise ValueError('noise_ratio should be between 0 and 1, actual value : {}'.format(noise_ratio))

def _check_MBR(MBR):
    if MBR < 0:
        raise ValueError('MBR should be non-negative, actual value : {}'.format(MBR))
