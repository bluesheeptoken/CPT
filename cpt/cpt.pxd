from cpt.prediction_tree cimport PredictionTree
from cpt.alphabet cimport Alphabet
from cpt.bitset cimport Bitset
from cpt.scorer cimport Scorer
from libcpp.vector cimport vector


cdef class Cpt:
    cdef:
        PredictionTree tree
        vector[Bitset] inverted_index
        vector[size_t] lookup_table

        int predict_seq(self, vector[int] target_sequence, vector[int] least_frequent_items, int MBR) nogil
        Bitset find_similar_sequences(self, vector[int] sequence) nogil
        int update_score(self, vector[int] suffix, Scorer& score) nogil

    cpdef predict(self, list sequences, float noise_ratio=*, int MBR=*, bint multithreading=*)

    cdef readonly:
        int split_index
        Alphabet alphabet
        size_t number_trained_sequences
