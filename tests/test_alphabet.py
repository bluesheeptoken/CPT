import unittest
import pickle

from cpt.alphabet import Alphabet


class AlphabetTest(unittest.TestCase):

    def setUp(self):
        self.alphabet = Alphabet()
        self.alphabet.add_symbol('C')
        self.alphabet.add_symbol('P')
        self.alphabet.add_symbol('T')

    def test_setup(self):
        self.assertEqual(self.alphabet.length, 3)
        self.assertEqual(self.alphabet.indexes, {'C': 0, 'P': 1, 'T': 2})
        self.assertEqual(self.alphabet.symbols, ['C', 'P', 'T'])

    def test_get_known_symbol(self):
        self.assertEqual(self.alphabet.get_symbol(0), 'C')

    def test_get_unknown_symbol(self):
        self.assertIsNone(self.alphabet.get_symbol(42))

    def test_get_known_index(self):
        self.assertEqual(self.alphabet.get_index('P'), 1)

    def test_get_unknown_index(self):
        self.assertEqual(self.alphabet.get_index('X'), -1)

    def test_add_known_symbol(self):
        self.assertEqual(self.alphabet.add_symbol('P'), 1)
        self.assertEqual(self.alphabet.length, 3)

    def test_add_unknown_symbol(self):
        self.assertEqual(self.alphabet.add_symbol('X'), 3)
        self.assertEqual(self.alphabet.length, 4)

    def test_richcmp(self):
        self.assertNotEqual(self.alphabet, Alphabet())
        alphabet = Alphabet()
        alphabet.add_symbol('C')
        alphabet.add_symbol('P')
        alphabet.add_symbol('T')
        self.assertEqual(self.alphabet, alphabet)

    def test_pickle(self):
        pickled = pickle.dumps(self.alphabet)
        unpickled_alphabet = pickle.loads(pickled)
        self.assertEqual(self.alphabet, unpickled_alphabet)
