# distutils: language = c++

from libcpp cimport bool
from libcpp.vector cimport vector
cdef extern from "cpp_sources/Bitset.cpp":
    pass


cdef extern from "cpp_sources/Bitset.hpp" nogil:
    cdef cppclass Bitset:
        Bitset() except +
        Bitset(size_t) except +
        Bitset(Bitset&) except +
        Bitset(const vector[unsigned char]&, size_t) except +
        size_t size()
        bool operator[](size_t)
        void add(size_t)
        float compute_frequency()
        Bitset& inter(Bitset&)
        void clear()
        void resize(size_t)
        const vector[unsigned char]& get_data()
