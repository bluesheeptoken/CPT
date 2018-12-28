import unittest

from cptCython.PredictionTree import PredictionTree


class PredictionTreeTest(unittest.TestCase):

    def setUp(self):
        self.root = PredictionTree()
        self.node_abc = self.root.add_child('A').add_child('B').add_child('C')
        self.root.add_child('B')

    def test_setup(self):
        self.assertIsNone(self.root.parent)
        self.assertIsNone(self.root.incoming_transition)
        self.assertEqual(list(self.root.children.keys()), ['A', 'B'])

        node_a = self.root.children['A']
        self.assertEqual(node_a.parent, self.root)
        self.assertEqual(node_a.incoming_transition, 'A')
        self.assertEqual(list(node_a.children.keys()), ['B'])

        node_ab = node_a.children['B']
        self.assertEqual(node_ab.parent, node_a)
        self.assertEqual(node_ab.incoming_transition, 'B')
        self.assertEqual(list(node_ab.children.keys()), ['C'])

        node_abc = node_ab.children['C']
        self.assertEqual(node_abc.parent, node_ab)
        self.assertEqual(node_abc.incoming_transition, 'C')
        self.assertEqual(list(node_abc.children.keys()), [])
        self.assertEqual(self.node_abc, node_abc)

        node_b = self.root.children['B']
        self.assertEqual(node_b.parent, self.root)
        self.assertEqual(node_b.incoming_transition, 'B')
        self.assertEqual(list(node_b.children.keys()), [])

    def test_get_known_child(self):
        self.assertEqual(self.root.get_child('A'), self.root.children['A'])

    def test_get_unknown_child(self):
        self.assertIsNone(self.root.get_child('C'))

    def test_add_known_child(self):
        self.assertEqual(self.root.add_child('A'), self.root.children['A'])

    def test_add_unknown_child(self):
        self.assertEqual(PredictionTree('C', self.root),
                         self.root.add_child('C'))
        self.assertEqual(len(self.root.children), 3)

    def test_generate_path_to_root(self):
        self.assertEqual(list(self.node_abc.generate_path_to_root()),
                         ['C', 'B', 'A'])

    def test_equal(self):
        tree_1 = PredictionTree()
        tree_1.add_child('A')
        tree_1.add_child('B')
        tree_2 = PredictionTree()
        tree_2.add_child('B')
        tree_2.add_child('A')
        self.assertEqual(tree_1, tree_2)

        tree_2.get_child('B').add_child('C')
        self.assertNotEqual(tree_1, tree_2)
