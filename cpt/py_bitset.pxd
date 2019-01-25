# distutils: language = c++
from libcpp.vector cimport vector
from libcpp cimport bool


cdef class BitSet:
    cdef public vector[bool] vector
    cpdef void inter(self, BitSet other) except *
    cpdef void add(self, int element)
    cpdef BitSet copy(self)
