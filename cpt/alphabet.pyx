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
