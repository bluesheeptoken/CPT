# distutils: language = c++
from libcpp.vector cimport vector
from libcpp cimport bool
from functools import reduce
from itertools import combinations

from cpt.prediction_tree cimport PredictionTree
from cpt.alphabet cimport Alphabet
from cpt.alphabet cimport NOT_AN_INDEX
from cpt.scorer cimport Scorer
from cpt.bitset cimport BitSet


cdef class Cpt:
    def __cinit__(self, split_length=0, max_level=1):
        self.root = PredictionTree()
        self.inverted_index = []
        self.lookup_table = []
        self.split_index = -split_length
        self.max_level = max_level
        self.alphabet = Alphabet()

    def train(self, sequences):

        number_train_sequences = len(sequences)

        for id_seq, sequence in enumerate(sequences):
            current = self.root
            for index in map(self.alphabet.add_symbol,
                             sequence[self.split_index:]):

                # Adding to the Prediction Tree
                current = current.add_child(index)

                # Adding to the Inverted Index
                if not index < len(self.inverted_index):
                    self.inverted_index.append(BitSet(number_train_sequences))

                self.inverted_index[index].add(id_seq)

            # Add the last node in the lookup_table
            self.lookup_table.append(current)

    def predict(self, sequences, number_predictions=5):
        return list(map(lambda seq: self.predict_seq(seq, number_predictions), sequences))

    cdef predict_seq(self, target_sequence, number_predictions=5):
        cdef vector[bool] vector
        cdef PredictionTree end_node
        cdef int next_transition, level, elt
        cdef tuple sequence
        cdef Scorer score
        cdef BitSet bitseq = BitSet(0)

        level = 0
        target_indexes_sequence = list(map(self.alphabet.get_index, target_sequence))
        score = Scorer(self.alphabet.length)

        while not score.predictable() and level < self.max_level:

            # Remove noise
            generated_sequences = \
                combinations(target_indexes_sequence, len(target_sequence) - level)

            # For each sequence, add to the corresponding score
            for sequence in generated_sequences:
                bitseq.vector.assign(self.alphabet.length, 0)
                for elt in sequence:
                    bitseq.add(elt)
                similar_sequences = self._find_similar_sequences(sequence)

                vector = similar_sequences.vector

                for similar_sequence_id in range(vector.size()):
                    if vector[similar_sequence_id]:
                        end_node = self.lookup_table[similar_sequence_id]
                        next_transition = end_node.incoming_transition

                        while not bitseq.vector[next_transition]:
                            score.update(next_transition)
                            end_node = end_node.parent
                            next_transition = end_node.incoming_transition
            level += 1

        return list(map(self.alphabet.get_symbol, score.best_n_predictions(number_predictions)))

    cpdef _find_similar_sequences(self, sequence):
        if not sequence or NOT_AN_INDEX in sequence:
            return BitSet(0)
        cdef BitSet bitset_temp
        bitset_temp = self.inverted_index[sequence[0]].copy()

        for i in range(1, len(sequence)):
            bitset_temp.inter(self.inverted_index[sequence[i]])

        return bitset_temp

    def __repr__(self):
        return self.root.__repr__()
