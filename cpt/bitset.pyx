# distutils: language = c++
from libcpp.vector cimport vector


cdef class BitSet:

    def __cinit__(self, int size):
        self.vector = vector[bint](size)

    cpdef void inter(self, BitSet other) except *:
        cdef int i
        cdef int minimal_size = min(self.vector.size(), other.vector.size())
        for i in range(minimal_size):
            self.vector[i] &= other.vector[i]
        self.vector.resize(minimal_size)

    cpdef void add(self, int element):
        if 0 <= element < self.vector.size():
            self.vector[element] = True

    cpdef BitSet copy(self):
        cdef BitSet new_bitset = BitSet(self.vector.size())
        for i in range(self.vector.size()):
            new_bitset.vector[i] = self.vector[i]
        return new_bitset

    def get_ints(self):
        return [x for x in range(self.vector.size()) if self.vector[x]]
