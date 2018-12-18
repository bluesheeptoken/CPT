class Alphabet():
    def __init__(self):
        self.length = 0
        self.indexes = {}
        self.symbols = []

    def get_symbol(self, index):
        if 0 <= index < self.length:
            return self.symbols[index]
        return None

    def get_symbols(self, indexes):
        return [self.get_symbol(index) for index in indexes]

    def get_index(self, symbol):
        return self.indexes.get(symbol)

    def get_indexes(self, symbols):
        return [self.get_index(symbol) for symbol in symbols]

    def add_symbol(self, symbol):
        index = self.indexes.setdefault(symbol, self.length)
        if index == self.length:
            self.symbols.append(symbol)
            self.length += 1
        return index

    def add_symbols(self, symbols):
        return [self.add_symbol(symbol) for symbol in symbols]

    def __repr__(self):
        return "{{length: {}, indexes: {}, symbols: {}}}"\
                .format(self.length, self.indexes, self.symbols)
