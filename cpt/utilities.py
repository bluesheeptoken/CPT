def sum_dictionnaries(dict1, dict2):
    return {k: dict1.get(k, 0) + dict2.get(k, 0) for k in set(dict1) | set(dict2)}


"""
The consequent of a sequence Y with respect to a sequence S 
is the subsequence of Y starting after the last item in
common with S until the end of Y
"""
def find_consequent(target_sequence, similar_sequence):
    for i in reversed(range(len(similar_sequence))):
        if similar_sequence[i] in target_sequence:
            return similar_sequence[i+1:]
    return []
