from functools import reduce
from itertools import combinations

from cpt import utilities
from cpt.PredictionTree import PredictionTree
from cpt.AlphabetInverter import AlphabetInverter
from cpt.Scorer import Scorer

class Cpt():
    def __init__(self, sequence_splitter=None, max_level=1):
        self.root = PredictionTree()
        self.inverted_index = {}
        self.lookup_table = {}
        self.sequence_splitter = -sequence_splitter if sequence_splitter is not None else None #pylint: disable=invalid-unary-operand-type
        self.max_level = max_level
        self.alphabet_inverter = AlphabetInverter()

    def train(self, sequences):
        cursornode = self.root

        for id_seq, sequence in enumerate(sequences):

            int_sequence = self.alphabet_inverter.elements_to_ints(sequence)

            for element in int_sequence[self.sequence_splitter:]:

                # Adding to the Prediction Tree
                if not cursornode.has_child(element):
                    cursornode.add_child(element)

                cursornode = cursornode.get_child(element)

                # Adding to the Inverted Index
                if element not in self.inverted_index:
                    self.inverted_index[element] = set()

                self.inverted_index[element].add(id_seq)

            # Add the last node in the lookup_table
            self.lookup_table[id_seq] = cursornode

            cursornode = self.root

        return True

    def predict(self, target_sequence, number_predictions=5):
        level = 0
        target_int_sequence = self.alphabet_inverter.elements_to_ints(target_sequence)
        score = Scorer(self.alphabet_inverter.alphabet_length)

        while not score.predictable() and level < self.max_level:

            # Remove noise
            generated_sequences = \
                list(combinations(target_int_sequence, len(target_int_sequence) - level))

            # For each sequence, add to the corresponding score
            for sequence in generated_sequences:
                similar_sequences = self._find_similar_sequences(sequence)

                consequent_sequences = list(map(lambda x: utilities.find_consequent(sequence, x),
                                                map(self._retrieve_sequence, similar_sequences)))

                score.update(consequent_sequences)

            level += 1

        return self.alphabet_inverter.ints_to_elements(
            score.best_n_predictions(number_predictions)
            )

    def _retrieve_sequence(self, id_seq):
        return self.lookup_table[id_seq].retrieve_path_from_root()

    def _find_similar_sequences(self, sequence):
        head, *queue = map(lambda x: self.inverted_index.get(x, set()), sequence)
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
            and self.alphabet_inverter == other.alphabet_inverter
