# distutils: language = c++

from libcpp cimport bool
cdef extern from "cpp_sources/PredictionTree.cpp":
    pass


cdef extern from "cpp_sources/PredictionTree.hpp":
    cdef cppclass PredictionTree:
        PredictionTree() nogil except +
        PredictionTree(int, PredictionTree) nogil except +
        PredictionTree* addChild(int) nogil
        PredictionTree* m_parent
        int m_incomingTransition
