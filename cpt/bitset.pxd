# distutils: language = c++

from libcpp cimport bool
cdef extern from "cpp_sources/Bitset.cpp":
    pass


cdef extern from "cpp_sources/Bitset.hpp" nogil:
    cdef cppclass Bitset:
        Bitset() except +
        Bitset(size_t) except +
        Bitset(Bitset&) except +
        size_t size()
        bool operator[](size_t)
        void add(size_t)
        float compute_frequency()
        bool contains(size_t)
        Bitset& inter(Bitset&)
        void clear()
