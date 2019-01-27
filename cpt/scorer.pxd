# distutils: language = c++

from libcpp cimport bool
cdef extern from "cpp_sources/Scorer.cpp":
    pass


cdef extern from "cpp_sources/Scorer.hpp":
    cdef cppclass Scorer:
        Scorer()
        Scorer(size_t)

        int get_score(size_t)
        void update(size_t)
        bool predictable()
        int get_best_prediction()
