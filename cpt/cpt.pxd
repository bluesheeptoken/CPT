from cpt.prediction_tree cimport PredictionTree
from cpt.alphabet cimport Alphabet


cdef class Cpt:
    cdef public PredictionTree root
    cdef public list inverted_index
    cdef public list lookup_table
    cdef public int split_index
    cdef public int max_level
    cdef public Alphabet alphabet
