import heapq


cdef class Scorer:
    def __cinit__(self, alphabet_length):
        self.alphabet_length = alphabet_length
        self.scoring = [0] * alphabet_length

    def predictable(self):
        return any(self.scoring)

    def update(self, int consequent_element):
        self.scoring[consequent_element] += 1

    def best_n_predictions(self, number_predictions):

        def get_score(int i):
            return self.scoring[i]

        return heapq.nlargest(number_predictions,
                              range(self.alphabet_length),
                              key=get_score)
