# distutils: language = c++
from libcpp.vector cimport vector
import heapq

from cpt.alphabet cimport NOT_AN_INDEX


cdef class Scorer:
    def __cinit__(self, int alphabet_length):
        self.scoring = vector[int](alphabet_length)

    cdef int get_score(self, int i):
        return self.scoring.at(i)

    def predictable(self):
        return any(self.scoring)

    cpdef void update(self, int consequent_element):
        self.scoring[consequent_element] += 1

    def get_best_predictions(self, number_predictions):

        return heapq.nlargest(number_predictions,
                              (x for x in range(self.scoring.size()) if self.scoring[x] != 0),
                              key=lambda x: self.get_score(x))

    def get_best_prediction(self):

        return max((x for x in range(self.scoring.size()) if self.scoring[x] != 0),
                   key=lambda x: self.get_score(x),
                   default=NOT_AN_INDEX)
