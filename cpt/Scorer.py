import heapq

class Scorer():
    def __init__(self, alphabet_length):
        self.alphabet_length = alphabet_length
        self.scoring = [0] * alphabet_length

    def predictable(self):
        return any(self.scoring)

    def update(self, consequent_element):
        self.scoring[consequent_element] += 1

    def best_n_predictions(self, number_predictions):
        return heapq.nlargest(number_predictions,
                              range(self.alphabet_length),
                              key=lambda i: (self.scoring[i], i))
