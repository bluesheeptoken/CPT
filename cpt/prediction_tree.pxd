# distutils: language = c++

from libcpp.vector cimport vector
from libcpp.map cimport map
cdef extern from "cpp_sources/PredictionTree.cpp":
    pass

ctypedef size_t Node

cdef enum:
    ROOT = 0

cdef extern from "cpp_sources/PredictionTree.hpp":
    cdef cppclass PredictionTree nogil:
        PredictionTree() except +
        PredictionTree(Node, const vector[int]&, const vector[int]&, const vector[map[int, Node]]&) except +
        Node addChild(Node, int)
        int getTransition(Node)
        Node getParent(Node)

        Node get_next_node()
        const vector[int]& get_incoming()
        const vector[int]& get_parent()
        const vector[map[int, Node]]& get_children()
