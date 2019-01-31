# distutils: language = c++

cdef extern from "cpp_sources/PredictionTree.cpp":
    pass

cdef enum:
    ROOT = 0

cdef extern from "cpp_sources/PredictionTree.hpp":
    cdef cppclass PredictionTree:
        PredictionTree() nogil except +
        size_t addChild(size_t, int) nogil
        int getTransition(size_t) nogil
        size_t getParent(size_t) nogil
