class PredictionTree():
    def __init__(self, incoming_transition=None, parent=None):
        self.children = {}
        self.incoming_transition = incoming_transition
        self.parent = parent

    def get_child(self, element):
        return self.children.get(element, None)

    def add_child(self, element):
        return self.children.setdefault(element, PredictionTree(element, self))

    def generate_path_to_root(self):
        current = self
        while current.incoming_transition is not None:
            yield current.incoming_transition
            current = current.parent

    def __repr__(self):
        return "{{'incoming_transition': {}, 'children': {}}}"\
                .format(self.incoming_transition, list(self.children.values()))

    def __eq__(self, other):
        return isinstance(other, PredictionTree) \
            and self.incoming_transition == other.incoming_transition \
            and self.children == other.children
