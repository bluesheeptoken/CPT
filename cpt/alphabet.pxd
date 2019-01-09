cdef enum:
    NOT_A_LETTER = -1

cdef class Alphabet:
    cdef public int length
    cdef public dict indexes
    cdef public list symbols
