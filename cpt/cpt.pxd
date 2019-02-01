from cpt.prediction_tree cimport PredictionTree
from cpt.alphabet cimport Alphabet
from cpt.bitset cimport Bitset
from libcpp.vector cimport vector


cdef class Cpt:
    cdef PredictionTree tree
    cdef vector[Bitset] inverted_index
    cdef vector[size_t] lookup_table
    cdef readonly int split_index
    cdef readonly int max_level
    cdef readonly Alphabet alphabet

    cdef predict_seq(self, list target_sequence)
    cdef Bitset _find_similar_sequences(self, vector[int] sequence) nogil
