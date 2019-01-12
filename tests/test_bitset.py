import unittest

from cpt.bitset import BitSet


class BitSetTest(unittest.TestCase):

    def setUp(self):
        self.bitset_1 = BitSet(5)
        self.bitset_1.add(0)
        self.bitset_1.add(4)
        self.bitset_2 = BitSet(6)
        self.bitset_2.add(0)
        self.bitset_2.add(5)

    def test_setup(self):
        ints_bitset_1 = [x for x in range(len(self.bitset_1.vector)) if self.bitset_1.vector[x]]
        self.assertEqual(ints_bitset_1, [0, 4])
        ints_bitset_2 = [x for x in range(len(self.bitset_2.vector)) if self.bitset_2.vector[x]]
        self.assertEqual(ints_bitset_2, [0, 5])

    def test_inter(self):
        self.bitset_1.inter(self.bitset_2)
        ints_bitset_inter = [x for x in range(len(self.bitset_1.vector)) if self.bitset_1.vector[x]]
        self.assertEqual(ints_bitset_inter, [0])
