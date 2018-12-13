from libcpp.map cimport map
from libcpp.string cimport string

cdef map[string, int] sum_dictionnaries(map[string, int] dict1, map[string, int] dict2):
    cdef map[string, int] answer
    return answer
    # return {k: dict1.get(k, 0) + dict2.get(k, 0) for k in set(dict1) | set(dict2)}

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
