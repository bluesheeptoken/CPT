import unittest

from cpt.Cpt import Cpt  # pylint: disable=no-name-in-module


class CptTest(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        cls.cpt = Cpt()
        cls.cpt.root.add_child(0)
        cls.cpt.root.get_child(0).add_child(1)
        cls.cpt.root.get_child(0).get_child(1).add_child(2)
        cls.cpt.root.get_child(0).get_child(1).add_child(3)

        cls.cpt.root.add_child(1)
        cls.cpt.root.get_child(1).add_child(2)
        cls.cpt.root.get_child(1).add_child(3)
        cls.cpt.root.get_child(1).get_child(3).add_child(4)
        cls.sequences = [['A', 'B', 'C'],
                         ['A', 'B'],
                         ['A', 'B', 'D'],
                         ['B', 'C'],
                         ['B', 'D', 'E']]

        cls.cpt.inverted_index = [{0, 1, 2},
                                  {0, 1, 2, 3, 4},
                                  {0, 3},
                                  {2, 4},
                                  {4}]

        cls.cpt.alphabet.length = 5
        cls.cpt.alphabet.indexes = {'A': 0, 'B': 1, 'C': 2, 'D': 3, 'E': 4}
        cls.cpt.alphabet.symbols = ['A', 'B', 'C', 'D', 'E']

        cls.cpt.lookup_table = [
            cls.cpt.root.get_child(0).get_child(1).get_child(2),
            cls.cpt.root.get_child(0).get_child(1),
            cls.cpt.root.get_child(0).get_child(1).get_child(3),
            cls.cpt.root.get_child(1).get_child(2),
            cls.cpt.root.get_child(1).get_child(3).get_child(4)
        ]

    def test_train(self):
        # GIVEN
        cpt = Cpt()
        cpt.train(self.sequences)

        # THEN
        self.assertEqual(self.cpt.inverted_index, cpt.inverted_index)
        self.assertEqual(self.cpt.lookup_table, cpt.lookup_table)
        self.assertEqual(self.cpt.root, cpt.root)

    def test_predict(self):
        # GIVEN
        target_sequence = [['A', 'B']]
        expected = [['C', 'D']]

        # WHEN
        actual = self.cpt.predict(target_sequence, 2)

        # THEN
        self.assertEqual(actual, expected)

    def test_find_similar_sequences(self):
        # GIVEN
        expected_not_empty = {0, 1, 2}
        sequence_in_alphabet = [0]
        expected_empty = set()
        sequence_not_in_alphabet = [None]

        # WHEN
        # pylint: disable=protected-access
        actual_not_empty = self.cpt._find_similar_sequences(sequence_in_alphabet)
        actual_empty = self.cpt._find_similar_sequences(sequence_not_in_alphabet)

        # THEN
        self.assertEqual(expected_not_empty, actual_not_empty)
        self.assertEqual(expected_empty, actual_empty)
