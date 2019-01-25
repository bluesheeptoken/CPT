import unittest

from cpt.py_bitset import BitSet


class BitSetTest(unittest.TestCase):

    def setUp(self):
        self.bitset_1 = BitSet(5)
        self.bitset_1.add(0)
        self.bitset_1.add(4)
        self.bitset_2 = BitSet(6)
        self.bitset_2.add(0)
        self.bitset_2.add(5)

    def test_setup(self):
        self.assertEqual(self.bitset_1.get_ints(), [0, 4])
        self.assertEqual(self.bitset_2.get_ints(), [0, 5])

    def test_copy(self):
        bitset_copy = self.bitset_1.copy()
        self.assertEqual(bitset_copy.get_ints(), [0, 4])
        bitset_copy.add(2)
        self.assertEqual(bitset_copy.get_ints(), [0, 2, 4])
        self.assertEqual(self.bitset_1.get_ints(), [0, 4])

    def test_inter(self):
        bitset = self.bitset_1.copy()
        bitset.inter(self.bitset_2)
        self.assertEqual(bitset.get_ints(), [0])
