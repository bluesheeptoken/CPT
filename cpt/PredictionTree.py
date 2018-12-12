class PredictionTree():
    def __init__(self, item=None, parent=None):
        self.item = item
        self.children = {}
        self.parent = parent

    def has_child(self, element):
        return element in self.children

    def add_child(self, element):
        self.children[element] = PredictionTree(element, self)
        return True

    def get_child(self, element):
        return self.children.get(element, None)

    def retrieve_path_from_root(self):
        def loop(cursor, sequence):
            if cursor.item is None:
                return sequence
            sequence.append(cursor.item)
            return loop(cursor.parent, sequence)
        return loop(self, [])[::-1]

    def __repr__(self):
        return "{{'item': {}, 'children': {}}}".format(self.item, list(self.children.values()))

    def __eq__(self, other):
        return isinstance(other, PredictionTree) \
            and self.item == other.item \
            and self.children == other.children
