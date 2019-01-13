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
        self.assertEqual(self.bitset_1.get_ints(), [0, 4])
        self.assertEqual(self.bitset_2.get_ints(), [0, 5])

    def test_inter(self):
        self.bitset_1.inter(self.bitset_2)
        ints_bitset_inter = [x for x in range(len(self.bitset_1.vector)) if self.bitset_1.vector[x]]
        self.assertEqual(ints_bitset_inter, [0])
