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


    def test_train(self):
        cpt = Cpt()
        cpt.train(self.sequences)

        # Check inverted index
        self.assertEqual(self.cpt.inverted_index, cpt.inverted_index)

        # Check tree
        self.assertEqual(self.cpt.root, cpt.root)

        # Check lookup_table
        self.assertEqual(self.cpt.lookup_table, cpt.lookup_table)
