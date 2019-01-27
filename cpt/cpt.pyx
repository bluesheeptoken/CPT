# distutils: language = c++
from libcpp.vector cimport vector
from libcpp cimport bool
from itertools import combinations

from cpt.prediction_tree cimport PredictionTree
from cpt.alphabet cimport Alphabet
from cpt.alphabet cimport NOT_AN_INDEX
from cpt.scorer cimport Scorer
from cpt.py_bitset cimport Bitset


cdef class Cpt:
    def __cinit__(self, split_length=0, max_level=1):
        self.root = PredictionTree()
        self.inverted_index = vector[Bitset]()
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
                if not index < self.inverted_index.size():
                    self.inverted_index.push_back(Bitset(number_train_sequences))

                self.inverted_index[index].add(id_seq)

            # Add the last node in the lookup_table
            self.lookup_table.append(current)

    def predict(self, list sequences):
        return [self.predict_seq(seq) for seq in sequences]

    cdef predict_seq(self, list target_sequence):
        cdef vector[bool] vector
        cdef PredictionTree end_node
        cdef int next_transition, level, elt
        cdef tuple sequence
        cdef Scorer score
        cdef Bitset bitseq = Bitset(self.alphabet.length)


        level = 0
        target_indexes_sequence = list(map(self.alphabet.get_index, target_sequence))
        score = Scorer(self.alphabet.length)

        while not score.predictable() and level < self.max_level:

            # Remove noise
            generated_sequences = \
                combinations(target_indexes_sequence, len(target_sequence) - level)

            # For each sequence, add to the corresponding score
            for sequence in generated_sequences:

                bitseq.clear()
                for elt in sequence:
                    if elt != NOT_AN_INDEX:
                        bitseq.add(elt)
                similar_sequences = self._find_similar_sequences(sequence)

                for similar_sequence_id in range(similar_sequences.size()):
                    if similar_sequences[similar_sequence_id]:
                        end_node = self.lookup_table[similar_sequence_id]
                        next_transition = end_node.incoming_transition

                        while not bitseq[next_transition]:
                            score.update(next_transition)
                            end_node = end_node.parent
                            next_transition = end_node.incoming_transition
            level += 1

        return self.alphabet.get_symbol(score.get_best_prediction())

    cdef Bitset _find_similar_sequences(self, sequence):
        if not sequence or NOT_AN_INDEX in sequence:
            return Bitset(self.alphabet.length)

        cdef Bitset bitset_temp
        cdef int i

        bitset_temp = Bitset(self.inverted_index[sequence[0]])
        for i in range(1, len(sequence)):
            bitset_temp.inter(self.inverted_index[sequence[i]])

        return bitset_temp

    def __repr__(self):
        return self.root.__repr__()
