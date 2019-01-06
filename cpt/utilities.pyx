from itertools import takewhile


def generate_consequent(target_sequence, similar_sequence_end_node):
    """
    The consequent of a sequence Y with respect to a sequence S
    is the subsequence of Y starting after the last item in
    common with S until the end of Y
    """
    return takewhile(lambda i: i not in target_sequence,
                     similar_sequence_end_node.generate_path_to_root())
    # order is reversed, but it has no impact on the scoring
