from cpython.object cimport Py_EQ, Py_NE


cdef class Alphabet:

    def __cinit__(self):
        self.length = 0
        self.indexes = {}
        self.symbols = []

    def get_symbol(self, int index):
        if 0 <= index < self.length:
            return self.symbols[index]
        return None

    def get_index(self, symbol):
        return self.indexes.get(symbol, NOT_AN_INDEX)

    def add_symbol(self, symbol):
        cdef int index = self.indexes.setdefault(symbol, self.length)
        if index == self.length:
            self.symbols.append(symbol)
            self.length += 1
        return index

    def __repr__(self):
        return "{{length: {}, indexes: {}, symbols: {}}}"\
                .format(self.length, self.indexes, self.symbols)

    def __getstate__(self):
        return (self.length, self.indexes, self.symbols)

    def __setstate__(self, state):
        length, indexes, symbols = state
        self.length = length
        self.indexes = indexes
        self.symbols = symbols

    def __is_equal__(self, other):
        return self.length == other.length and \
               self.indexes == other.indexes and \
               self.symbols == other.symbols

    def __richcmp__(self, other, op):
        if op == Py_EQ:
            return self.__is_equal__(other)
        elif op == Py_NE:
            return not self.__is_equal__(other)
        else:
            assert False

