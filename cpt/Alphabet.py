class Alphabet():
    def __init__(self):
        self.alphabet_length = 0
        self.symbol_to_index = {}
        self.index_to_symbol = []

    def symbols_to_indexes(self, symbols):
        return [self._get_index(symbol) for symbol in symbols]

    def indexes_to_symbols(self, ints):
        return [self._get_symbol(i) for i in ints]

    def _add_symbol(self, symbol):
        self.index_to_symbol.append(symbol)
        self.symbol_to_index[symbol] = self.alphabet_length
        self.alphabet_length += 1

    def _get_index(self, symbol):
        if symbol not in self.symbol_to_index.keys():
            self._add_symbol(symbol)
        return self.symbol_to_index[symbol]

    def _get_symbol(self, index):
        return self.index_to_symbol[index]

    def __repr__(self):
        return "{{alphabet_length: {}, symbol_to_index: {}, index_to_symbol: {}}}"\
                .format(self.alphabet_length, self.symbol_to_index, self.index_to_symbol)
