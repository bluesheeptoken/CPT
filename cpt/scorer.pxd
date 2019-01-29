# distutils: language = c++

from libcpp cimport bool
cdef extern from "cpp_sources/Scorer.cpp":
    pass


cdef extern from "cpp_sources/Scorer.hpp":
    cdef cppclass Scorer:
        Scorer() nogil except +
        Scorer(size_t) nogil except +

        int get_score(size_t) nogil
        void update(size_t) nogil
        bool predictable() nogil
        int get_best_prediction() nogil
