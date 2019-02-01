# distutils: language = c++
from libcpp.vector cimport vector
from libcpp cimport bool
from itertools import combinations

from cpt.prediction_tree cimport PredictionTree, Node, ROOT
from cpt.alphabet cimport Alphabet
from cpt.alphabet cimport NOT_AN_INDEX
from cpt.scorer cimport Scorer
from cpt.bitset cimport Bitset


cdef extern from "<algorithm>" namespace "std" nogil:
    Iter find[Iter](Iter first, Iter last, int val)

cdef class Cpt:
    def __cinit__(self, int split_length=0, int max_level=1):
        self.tree = PredictionTree()
        self.inverted_index = vector[Bitset]()
        self.lookup_table = vector[Node]()
        self.split_index = -split_length
        self.max_level = max_level
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

    cpdef predict(self, list sequences):
        cdef vector[int] sequence_indexes
        cdef Py_ssize_t i
        predictions = []
        for i in range(len(sequences)):
            sequence = sequences[i]
            sequence_indexes = <vector[int]>[self.alphabet.get_index(symbol) for symbol in sequence]
            predictions.append(self.alphabet.get_symbol(self.predict_seq(sequence_indexes)))
        return predictions

    cdef int predict_seq(self, vector[int] target_sequence):
        cdef:
            Node end_node
            int next_transition, level, elt
            tuple sequence
            Scorer score
            Bitset bitseq = Bitset(self.alphabet.length)

        level = 0
        score = Scorer(self.alphabet.length)

        while not score.predictable() and level < self.max_level and 0 < len(target_sequence) - level:

            # Remove noise
            generated_sequences = \
                combinations(target_sequence, len(target_sequence) - level)

            # For each sequence, add to the corresponding score
            for sequence in generated_sequences:

                bitseq.clear()
                for elt in sequence:
                    if elt != NOT_AN_INDEX:
                        bitseq.add(elt)
                similar_sequences = self._find_similar_sequences(<vector[int]>sequence)

                for similar_sequence_id in range(similar_sequences.size()):
                    if similar_sequences[similar_sequence_id]:
                        end_node = self.lookup_table[similar_sequence_id]
                        next_transition = self.tree.getTransition(end_node)

                        while not bitseq[next_transition]:
                            score.update(next_transition)
                            end_node = self.tree.getParent(end_node)
                            next_transition = self.tree.getTransition(end_node)
            level += 1

        return score.get_best_prediction()

    cdef Bitset _find_similar_sequences(self, vector[int] sequence) nogil:
        if sequence.empty() or find(sequence.begin(), sequence.end(), NOT_AN_INDEX) != sequence.end():
            return Bitset(self.alphabet.length)

        cdef Bitset bitset_temp
        cdef size_t i

        bitset_temp = Bitset(self.inverted_index[sequence[0]])
        for i in range(1, sequence.size()):
            bitset_temp.inter(self.inverted_index[sequence[i]])

        return bitset_temp
