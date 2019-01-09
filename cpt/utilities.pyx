from cpt.alphabet cimport NOT_A_LETTER


cdef list generate_consequent(tuple target_sequence, PredictionTree end_node):
    """
    The consequent of a sequence Y with respect to a sequence S
    is the subsequence of Y starting after the last item in
    common with S until the end of Y
    """
    consequent_sequence = []
    cdef int next_transition = end_node.incoming_transition
    while next_transition != NOT_A_LETTER and next_transition not in target_sequence:
        consequent_sequence.append(next_transition)
        end_node = end_node.parent
        next_transition = end_node.incoming_transition
    return consequent_sequence
    # order is reversed, but it has no impact on the scoring
