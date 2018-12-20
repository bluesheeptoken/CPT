from functools import reduce
from itertools import combinations

from cpt import utilities
from cpt.PredictionTree import PredictionTree
from cpt.Alphabet import Alphabet
from cpt.Scorer import Scorer

class Cpt():
    def __init__(self, sequence_splitter=None, max_level=1):
        self.root = PredictionTree()
        self.inverted_index = []
        self.lookup_table = []
        self.sequence_splitter = -sequence_splitter if sequence_splitter is not None else None #pylint: disable=invalid-unary-operand-type
        self.max_level = max_level
        self.alphabet = Alphabet()

    def train(self, sequences):

        for id_seq, sequence in enumerate(sequences):
            current = self.root
            for index in map(self.alphabet.add_symbol, sequence[self.sequence_splitter:]):

                # Adding to the Prediction Tree
                current = current.add_child(index)

                # Adding to the Inverted Index
                if not index < len(self.inverted_index):
                    self.inverted_index.append(set())

                self.inverted_index[index].add(id_seq)

            # Add the last node in the lookup_table
            self.lookup_table.append(current)

    def predict(self, target_sequence, number_predictions=5):
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
                    utilities.generate_consequent(sequence, self.lookup_table[similar_sequence_id]):
                        score.update(consequent_symbol_index)
            level += 1

        return list(map(self.alphabet.get_symbol, score.best_n_predictions(number_predictions)))

    def _find_similar_sequences(self, sequence):

        def _get_invert_index(index):
            if index is not None:
                return self.inverted_index[index]
            return set()

        head, *queue = map(_get_invert_index, sequence)
        return reduce(lambda x, y: x & y, queue, head)

    def __repr__(self):
        return self.root.__repr__()

    def __equal__(self, other):
        return isinstance(other, Cpt) \
            and self.root == other.root \
            and self.inverted_index == other.inverted_index \
            and self.lookup_table == other.lookup_table \
            and self.sequence_splitter == other.sequence_splitter \
            and self.max_level == other.max_level \
            and self.alphabet == other.alphabet
