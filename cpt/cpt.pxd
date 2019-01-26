from cpt.prediction_tree cimport PredictionTree
from cpt.alphabet cimport Alphabet
from cpt.py_bitset cimport Bitset
from libcpp.vector cimport vector


cdef class Cpt:
    cdef public PredictionTree root
    cdef vector[Bitset] inverted_index
    cdef public list lookup_table
    cdef public int split_index
    cdef public int max_level
    cdef public Alphabet alphabet

    cdef predict_seq(self, list target_sequence, int number_predictions=*)
    cdef Bitset _find_similar_sequences(self, sequence)
