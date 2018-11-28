from functools import reduce
from itertools import combinations

from cpt import utilities
from cpt.PredictionTree import PredictionTree


class Cpt():
    def __init__(self, sequence_splitter=None, max_level=1):
        self.alphabet = set()
        self.root = PredictionTree()
        self.inverted_index = {}
        self.lookup_table = {}
        self.sequence_splitter = -sequence_splitter if sequence_splitter is not None else None #pylint: disable=invalid-unary-operand-type
        self.max_level = max_level

    def train(self, sequences):
        cursornode = self.root

        for id_seq, sequence in enumerate(sequences):
            for element in sequence[self.sequence_splitter:]:


                # adding to the Prediction Tree
                if not cursornode.has_child(element):
                    cursornode.add_child(element)

                cursornode = cursornode.get_child(element)

                # Adding to the Inverted Index

                if element not in self.inverted_index:
                    self.inverted_index[element] = set()

                self.inverted_index[element].add(id_seq)

                self.alphabet.add(element)

            self.lookup_table[id_seq] = cursornode

            cursornode = self.root

        return True

    def retrieve_sequence(self, id_seq):
        return self.lookup_table[id_seq].retrieve_path_from_root()

    def find_similar_sequences(self, sequence):
        head, *queue = map(lambda x: self.inverted_index.get(x, set()), sequence)
        return reduce(lambda x, y: x & y, queue, head)

    def get_score(self, consequent_sequences):
        count_table = {}

        for consequent in consequent_sequences:
            for element in consequent:
                count_table[element] = count_table.get(element, 0) + 1

        return count_table

    def predict(self, target_sequence):
        level = 0

        scores = {}
        while not scores and level < self.max_level:
            generated_sequences = list(combinations(target_sequence, len(target_sequence) - level))

            for sequence in generated_sequences:
                similar_sequences = self.find_similar_sequences(sequence)

                consequent_sequences = list(map(lambda x: utilities.find_consequent(sequence, x),
                                                map(self.retrieve_sequence, similar_sequences)))

                scores = utilities.sum_dictionnaries(scores, self.get_score(consequent_sequences))
            level += 1

        return scores

    def __repr__(self):
        return ""
