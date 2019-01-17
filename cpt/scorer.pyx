# distutils: language = c++
from libcpp.vector cimport vector
import heapq

from cpt.alphabet cimport NOT_AN_INDEX


cdef class Scorer:
    def __cinit__(self, int alphabet_length):
        self.scoring = vector[int](alphabet_length)

    def predictable(self):
        return any(self.scoring)

    def update(self, int consequent_element):
        self.scoring[consequent_element] += 1

    def best_n_predictions(self, number_predictions):

        def get_score(int i):
            return self.scoring[i]

        if number_predictions > 1:
            return heapq.nlargest(number_predictions,
                                  (x for x in range(self.scoring.size()) if self.scoring[x] != 0),
                                  key=get_score)
        else:
            return max((x for x in range(self.scoring.size()) if self.scoring[x] != 0),
                       key=get_score,
                       default=NOT_AN_INDEX)
