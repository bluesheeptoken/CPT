# distutils: language = c++

cdef extern from "cpp_sources/PredictionTree.cpp":
    pass

ctypedef size_t Node

cdef enum:
    ROOT = 0

cdef extern from "cpp_sources/PredictionTree.hpp":
    cdef cppclass PredictionTree:
        PredictionTree() nogil except +
        Node addChild(Node, int) nogil
        int getTransition(Node) nogil
        Node getParent(Node) nogil
