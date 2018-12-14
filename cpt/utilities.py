def find_consequent(target_sequence, similar_sequence):
    """
    The consequent of a sequence Y with respect to a sequence S
    is the subsequence of Y starting after the last item in
    common with S until the end of Y
    """
    for i in reversed(range(len(similar_sequence))):
        if similar_sequence[i] in target_sequence:
            return similar_sequence[i+1:]
    return []
