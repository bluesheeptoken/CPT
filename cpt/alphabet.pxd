cdef enum:
    NOT_AN_INDEX = -1

cdef class Alphabet:
    cdef public int length
    cdef public dict indexes
    cdef public list symbols
