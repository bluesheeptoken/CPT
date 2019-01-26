# distutils: language = c++

from libcpp cimport bool
cdef extern from "cpp_sources/Bitset.cpp":
    pass


cdef extern from "cpp_sources/Bitset.hpp":
    cdef cppclass Bitset:
        Bitset() except +
        Bitset(size_t) except +
        Bitset(Bitset&) except +
        size_t size()
        bool operator[](size_t)
        void add(size_t)
        Bitset& inter(Bitset&)
        void clear()
