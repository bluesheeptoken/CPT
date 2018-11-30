import unittest

from cpt.Cpt import Cpt


class CptTest(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        cls.cpt = Cpt()
        cls.cpt.root.add_child('A')
        cls.cpt.root.get_child('A').add_child('B')
        cls.cpt.root.get_child('A').get_child('B').add_child('C')
        cls.cpt.root.get_child('A').get_child('B').add_child('D')

        cls.cpt.root.add_child('B')
        cls.cpt.root.get_child('B').add_child('C')
        cls.cpt.root.get_child('B').add_child('D')
        cls.cpt.root.get_child('B').get_child('D').add_child('E')
        cls.sequences = [['A', 'B', 'C'],
                         ['A', 'B'],
                         ['A', 'B', 'D'],
                         ['B', 'C'],
                         ['B', 'D', 'E']]

        cls.cpt.inverted_index = {'A': {0, 1, 2},
                                  'B': {0, 1, 2, 3, 4},
                                  'C': {0, 3},
                                  'D': {2, 4},
                                  'E': {4}}

        cls.cpt.lookup_table = {0: cls.cpt.root.get_child('A').get_child('B').get_child('C'),
                                1: cls.cpt.root.get_child('A').get_child('B'),
                                2: cls.cpt.root.get_child('A').get_child('B').get_child('D'),
                                3: cls.cpt.root.get_child('B').get_child('C'),
                                4: cls.cpt.root.get_child('B').get_child('D').get_child('E')}

        cls.cpt.alphabet = {'A', 'B', 'C', 'D', 'E'}

    def test_train(self):
        cpt = Cpt()
        cpt.train(self.sequences)

        # Check inverted index
        self.assertEqual(self.cpt.inverted_index, cpt.inverted_index)

        # Check tree
        self.assertEqual(self.cpt.root, cpt.root)

        # Check lookup_table
        self.assertEqual(self.cpt.lookup_table, cpt.lookup_table)

        # Check alphabet
        self.assertEqual(self.cpt.alphabet, cpt.alphabet)

    def test_retrieve_sequence(self):
        # GIVEN
        expected = ['A', 'B', 'C']

        # WHEN
        actual = self.cpt.retrieve_sequence(0)

        # THEN
        self.assertEqual(expected, actual)

    def test_find_similar_sequences(self):
        # GIVEN
        expected_not_empty = {0, 1, 2}
        sequence_in_alphabet = ['A']
        expected_empty = set()
        sequence_not_in_alphabet = ['F']

        # WHEN
        actual_not_empty = self.cpt.find_similar_sequences(sequence_in_alphabet)
        actual_empty = self.cpt.find_similar_sequences(sequence_not_in_alphabet)


        # THEN
        self.assertEqual(expected_not_empty, actual_not_empty)
        self.assertEqual(expected_empty, actual_empty)

    def test_get_score(self):
        # GIVEN
        consequent_sequence = ['B', 'B', 'C']
        expected = {'B': 2, 'C': 1}

        # WHEN
        actual = self.cpt.get_score(consequent_sequence)

        # THEN
        self.assertEqual(actual, expected)

    def test_predict(self):
        # GIVEN
        target_sequence = ['A', 'B']
        expected = ['C', 'D']

        # WHEN
        actual = self.cpt.predict(target_sequence)

        # THEN
        self.assertEqual(actual, expected)
