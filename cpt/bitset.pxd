# distutils: language = c++

from libcpp cimport bool
cdef extern from "cpp_sources/Bitset.cpp":
    pass


cdef extern from "cpp_sources/Bitset.hpp":
    cdef cppclass Bitset:
        Bitset() nogil except +
        Bitset(size_t) nogil except +
        Bitset(Bitset&) nogil except +
        size_t size() nogil
        bool operator[](size_t) nogil
        void add(size_t) nogil
        bool contains(size_t) nogil
        Bitset& inter(Bitset&) nogil
        void clear() nogil
