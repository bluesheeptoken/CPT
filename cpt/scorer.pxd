# distutils: language = c++
from libcpp.vector cimport vector


cdef class Scorer:
    cdef public vector[int] scoring
    cdef int get_score(self, int i)
    cpdef void update(self, int consequent_element)
