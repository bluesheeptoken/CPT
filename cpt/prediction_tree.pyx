from cpython.object cimport Py_EQ, Py_NE
from cpt.alphabet cimport NOT_AN_INDEX


cdef class PredictionTree:
    def __cinit__(self, incoming_transition=NOT_AN_INDEX, parent=None):
        self.children = {}
        self.incoming_transition = incoming_transition
        self.parent = parent

    def get_child(self, element):
        return self.children.get(element, None)

    def add_child(self, element):
        return self.children.setdefault(element, PredictionTree(element, self))

    def generate_path_to_root(self):
        current = self
        ans = []
        while current.incoming_transition != NOT_AN_INDEX:
            ans.append(current.incoming_transition)
            current = current.parent
        return ans

    def __repr__(self):
        return "{{'incoming_transition': {}, 'children': {}}}"\
                .format(self.incoming_transition, list(self.children.values()))

    def __is_equal(self, other):
        return isinstance(other, PredictionTree) \
                and self.incoming_transition == other.incoming_transition \
                and self.children == other.children

    def __richcmp__(self, other, op):
        if op == Py_EQ:
            return self.__is_equal(other)
        elif op == Py_NE:
            return not self.__is_equal(other)
        else:
            assert False
