cdef class PredictionTree:
    cdef public dict children
    cdef public int incoming_transition
    cdef public PredictionTree parent