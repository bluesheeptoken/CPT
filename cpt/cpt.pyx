# distutils: language = c++

from libcpp.vector cimport vector
from libcpp.queue cimport queue
from libcpp.iterator cimport back_inserter
from cython.parallel import prange

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
    def __cinit__(self, int split_length=0):
        self.tree = PredictionTree()
        self.inverted_index = vector[Bitset]()
        self.lookup_table = vector[Node]()
        self.split_index = -split_length
        self.alphabet = Alphabet()

    def train(self, sequences):

        number_train_sequences = len(sequences)
        cdef Node current
        for id_seq, sequence in enumerate(sequences):
            current = ROOT
            for index in map(self.alphabet.add_symbol,
                             sequence[self.split_index:]):

                # Adding to the Prediction Tree
                current = self.tree.addChild(current, index)

                # Adding to the Inverted Index
                if not index < self.inverted_index.size():
                    self.inverted_index.push_back(Bitset(number_train_sequences))

                self.inverted_index[index].add(id_seq)

            # Add the last node in the lookup_table
            self.lookup_table.push_back(current)

    cpdef predict(self, list sequences, float noise_ratio, int MBR, bint multi_threading=True):
        cdef:
            vector[int] least_frequent_items = vector[int](), sequence_indexes
            vector[vector[int]] sequences_indexes = vector[vector[int]]()
            Py_ssize_t i, j
            int len_sequences = len(sequences)
            vector[int] int_predictions

        for i in range(self.alphabet.length):
            if self.inverted_index[i].compute_frequency() <= noise_ratio:
                least_frequent_items.push_back(i)

        if multi_threading:
            int_predictions = vector[int](len_sequences)
            sequences_indexes = vector[vector[int]]()
            for i in range(len_sequences):
                sequence = sequences[i]
                sequence_indexes = vector[int]()
                for j in range(len(sequence)):
                    sequence_indexes.push_back(self.alphabet.get_index(sequence[j]))
                sequences_indexes.push_back(sequence_indexes)

            for i in prange(len_sequences, nogil=True, schedule='dynamic'):
                int_predictions[i] = self.predict_seq(sequences_indexes[i], least_frequent_items, MBR)

        else:
            for i in range(len_sequences):
                sequence = sequences[i]
                sequence_indexes = vector[int]()
                for j in range(len(sequence)):
                    sequence_indexes.push_back(self.alphabet.get_index(sequence[j]))
                int_predictions.push_back(self.predict_seq(sequence_indexes, least_frequent_items, MBR))

        return [self.alphabet.get_symbol(x) for x in int_predictions]

    cdef int predict_seq(self, vector[int] target_sequence, vector[int] least_frequent_items, int MBR) nogil:
        cdef:
            Scorer scorer = Scorer(self.alphabet.length)
            queue[vector[int]] suffixes = queue[vector[int]]()
            vector[int] suffix_without_noise, suffix
            size_t i
            int noise, update_count = 0

        target_sequence.erase(remove(target_sequence.begin(), target_sequence.end(), NOT_AN_INDEX), target_sequence.end())

        suffixes.push(target_sequence)
        update_count += self.update_score(target_sequence, scorer)

        while update_count < MBR and not suffixes.empty():
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

    cdef Bitset find_similar_sequences(self, vector[int] sequence) nogil:
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
        similar_sequences = self.find_similar_sequences(suffix)

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
