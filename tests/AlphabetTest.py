import unittest

from cpt.Alphabet import Alphabet

class AlphabetTest(unittest.TestCase):

    def setUp(self):
        self.alphabet = Alphabet()
        self.alphabet.add_symbols("CPT")

    def test_setup(self):
        self.assertEqual(self.alphabet.length, 3)
        self.assertEqual(self.alphabet.indexes, {'C':0, 'P':1, 'T':2})
        self.assertEqual(self.alphabet.symbols, ['C', 'P', 'T'])

    def test_get_known_symbol(self):
        self.assertEqual(self.alphabet.get_symbol(0), 'C')

    def test_get_unknown_symbol(self):
        self.assertIsNone(self.alphabet.get_symbol(42))

    def test_get_symbols(self):
        self.assertEqual(self.alphabet.get_symbols([0, 42, 1]), ['C', None, 'P'])

    def test_get_known_index(self):
        self.assertEqual(self.alphabet.get_index('P'), 1)

    def test_get_unknown_index(self):
        self.assertIsNone(self.alphabet.get_index('X'))

    def test_get_indexes(self):
        self.assertEqual(self.alphabet.get_indexes("ABC"), [None, None, 0])

    def test_add_known_symbol(self):
        self.assertEqual(self.alphabet.add_symbol('P'), 1)
        self.assertEqual(self.alphabet.length, 3)

    def test_add_unknown_symbol(self):
        self.assertEqual(self.alphabet.add_symbol('X'), 3)
        self.assertEqual(self.alphabet.length, 4)

    def test_add_symbols(self):
        self.assertEqual(self.alphabet.add_symbols("XYZT"), [3, 4, 5, 2])
        self.assertEqual(self.alphabet.length, 6)
