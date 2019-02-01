from cpt.prediction_tree cimport PredictionTree
from cpt.alphabet cimport Alphabet
from cpt.bitset cimport Bitset
from libcpp.vector cimport vector


cdef class Cpt:
    cdef:
        PredictionTree tree
        vector[Bitset] inverted_index
        vector[size_t] lookup_table

        int predict_seq(self, vector[int] target_sequence)
        Bitset _find_similar_sequences(self, vector[int] sequence) nogil

    cdef readonly:
        int split_index
        int max_level
        Alphabet alphabet
