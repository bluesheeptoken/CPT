class AlphabetInverter():
    def __init__(self):
        self.alphabet_length = 0
        self.alphabet_to_ints = {}
        self.int_to_element = []

    def add_element(self, element):
        self.int_to_element.append(element)
        self.alphabet_to_ints[element] = self.alphabet_length
        self.alphabet_length += 1

    def elements_to_ints(self, elements):
        ans = []
        for element in elements:
            if element not in self.alphabet_to_ints.keys():
                self.add_element(element)
            ans.append(self.alphabet_to_ints[element])
        return ans

    def ints_to_elements(self, ints):
        ans = []
        for i in ints:
            ans.append(self.int_to_element[i])
        return ans

    def __repr__(self):
        return "{{alphabet_length: {}, alphabet_to_ints: {}, int_to_element: {}}}"\
                .format(self.alphabet_length, self.alphabet_to_ints, self.int_to_element)
