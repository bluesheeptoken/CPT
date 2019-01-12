# distutils: language = c++
from libcpp.vector cimport vector


cdef class BitSet:
    cdef public vector[bint] vector
    cpdef void inter(self, BitSet other) except *
    cpdef void add(self, int element)
