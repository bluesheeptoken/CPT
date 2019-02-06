# distutils: language = c++

from libcpp.vector cimport vector
from libcpp cimport bool

cdef extern from "cpp_sources/Scorer.cpp":
    pass


cdef extern from "cpp_sources/Scorer.hpp" nogil:
    cdef cppclass Scorer:
        Scorer() except +
        Scorer(size_t) except +

        int get_score(size_t)
        void update(size_t)
        bool predictable()
        int get_best_prediction()
