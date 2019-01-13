from functools import reduce
from itertools import combinations

from cpt.utilities cimport generate_consequent
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

    def predict_seq(self, target_sequence, number_predictions=5):
        level = 0
        target_indexes_sequence = list(map(self.alphabet.get_index, target_sequence))
        score = Scorer(self.alphabet.length)

        while not score.predictable() and level < self.max_level:

            # Remove noise
            generated_sequences = \
                list(combinations(target_indexes_sequence, len(target_indexes_sequence) - level))

            # For each sequence, add to the corresponding score
            for sequence in generated_sequences:
                for similar_sequence_id in self._find_similar_sequences(sequence):
                    for consequent_symbol_index in \
                        generate_consequent(sequence,
                                            self.lookup_table[similar_sequence_id]):
                        score.update(consequent_symbol_index)
            level += 1

        return list(map(self.alphabet.get_symbol, score.best_n_predictions(number_predictions)))

    def _find_similar_sequences(self, sequence):

        if not sequence or NOT_AN_INDEX in sequence:
            return []

        bitset_temp = self.inverted_index[sequence[0]].copy()

        for i in range(1, len(sequence)):
            bitset_temp.inter(self.inverted_index[sequence[i]])

        return bitset_temp.get_ints()

    def __repr__(self):
        return self.root.__repr__()
