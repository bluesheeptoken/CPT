class Alphabet():
    def __init__(self):
        self.length = 0
        self.indexes = {}
        self.symbols = []

    def get_symbol(self, index):
        if 0 <= index < self.length:
            return self.symbols[index]
        return None

    def get_index(self, symbol):
        return self.indexes.get(symbol)

    def add_symbol(self, symbol):
        index = self.indexes.setdefault(symbol, self.length)
        if index == self.length:
            self.symbols.append(symbol)
            self.length += 1
        return index

    def __repr__(self):
        return "{{length: {}, indexes: {}, symbols: {}}}"\
                .format(self.length, self.indexes, self.symbols)
