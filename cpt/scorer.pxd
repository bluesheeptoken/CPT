# distutils: language = c++
from libcpp.vector cimport vector


cdef class Scorer:
    cdef public vector[int] scoring
