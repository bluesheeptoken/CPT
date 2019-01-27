import unittest

from cpt.cpt import Cpt  # pylint: disable=no-name-in-module
from cpt.alphabet import Alphabet


class CptTest(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        cls.cpt = Cpt(max_level=3)

        cls.sequences = [['A', 'B', 'C'],
                         ['A', 'B'],
                         ['A', 'B', 'D'],
                         ['B', 'C'],
                         ['B', 'D', 'E']]

        cls.cpt.train(cls.sequences)

    def test_train(self):
        self.assertEqual(self.cpt.lookup_table, [
            self.cpt.root.get_child(0).get_child(1).get_child(2),
            self.cpt.root.get_child(0).get_child(1),
            self.cpt.root.get_child(0).get_child(1).get_child(3),
            self.cpt.root.get_child(1).get_child(2),
            self.cpt.root.get_child(1).get_child(3).get_child(4)
        ])
        alphabet = Alphabet()
        alphabet.length = 5
        alphabet.indexes = {'A': 0, 'B': 1, 'C': 2, 'D': 3, 'E': 4}
        alphabet.symbols = ['A', 'B', 'C', 'D', 'E']
        self.assertEqual(self.cpt.alphabet.length, alphabet.length)
        self.assertEqual(self.cpt.alphabet.indexes, alphabet.indexes)
        self.assertEqual(self.cpt.alphabet.symbols, alphabet.symbols)

    def test_predict(self):
        # First sequence does not have noise, second has
        self.assertEqual(self.cpt.predict([['A', 'B'], ['A', 'B', 'G', 'G']]),
                         ['C', 'C'])
