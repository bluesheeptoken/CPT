# distutils: language = c++

cdef extern from "cpp_sources/PredictionTree.cpp":
    pass

ctypedef size_t Node

cdef enum:
    ROOT = 0

cdef extern from "cpp_sources/PredictionTree.hpp":
    cdef cppclass PredictionTree nogil:
        PredictionTree() except +
        Node addChild(Node, int)
        int getTransition(Node)
        Node getParent(Node)
