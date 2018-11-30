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
        if self.has_child(element):
            return self.children[element]

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
        if isinstance(other, PredictionTree):
            if len(self.children) == len(other.children):
                return self.item == other.item and \
                       all(x == y for x, y in zip(self.children.values(), other.children.values()))
        return False
