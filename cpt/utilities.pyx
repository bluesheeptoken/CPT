#  Todo: replace list with the new Prediction Tree extension type to avoid bad performances due to the conversion
cdef list generate_consequent(tuple target_sequence, list similar_sequence):
    """
    The consequent of a sequence Y with respect to a sequence S
    is the subsequence of Y starting after the last item in
    common with S until the end of Y
    """
    ans = []
    cdef int i
    for i in similar_sequence:
        if i in target_sequence:
            break
        ans.append(i)
    return ans
    # order is reversed, but it has no impact on the scoring
