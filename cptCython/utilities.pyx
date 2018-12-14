# distutils: language = c++

from cython.operator cimport dereference, preincrement
from libcpp.map cimport map
from libcpp.string cimport string

def sum_dictionnaries(map[string, int] dict1, map[string, int] dict2):
    cdef:
        map[string, int].iterator it1, it2
        string k
        int v
    it2 = dict2.begin()
    while it2 != dict2.end():
        k = dereference(it2).first
        v = dereference(it2).second
        it1 = dict1.find(k)
        if it1 != dict1.end():
            dereference(it1).second += v
        else:
            dict1[k] = v
        preincrement(it2)
    return dict1

def find_consequent(target_sequence, similar_sequence):
    """
    The consequent of a sequence Y with respect to a sequence S
    is the subsequence of Y starting after the last item in
    common with S until the end of Y
    """
    cdef int i
    for i in range(len(similar_sequence) - 1, -1 , -1):
        if similar_sequence[i] in target_sequence:
            # return similar_sequence[i+1:]
            return 2
    return 0
