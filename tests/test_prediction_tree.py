import unittest

from cpt.prediction_tree import PredictionTree


class PredictionTreeTest(unittest.TestCase):

    def setUp(self):
        self.root = PredictionTree()
        self.node_abc = self.root.add_child(0).add_child(1).add_child(2)
        self.root.add_child(1)

    def test_setup(self):
        self.assertIsNone(self.root.parent)
        self.assertEqual(self.root.incoming_transition, -1)
        self.assertEqual(list(self.root.children.keys()), [0, 1])

        node_a = self.root.children[0]
        self.assertEqual(node_a.parent, self.root)
        self.assertEqual(node_a.incoming_transition, 0)
        self.assertEqual(list(node_a.children.keys()), [1])

        node_ab = node_a.children[1]
        self.assertEqual(node_ab.parent, node_a)
        self.assertEqual(node_ab.incoming_transition, 1)
        self.assertEqual(list(node_ab.children.keys()), [2])

        node_abc = node_ab.children[2]
        self.assertEqual(node_abc.parent, node_ab)
        self.assertEqual(node_abc.incoming_transition, 2)
        self.assertEqual(list(node_abc.children.keys()), [])
        self.assertEqual(self.node_abc, node_abc)

        node_b = self.root.children[1]
        self.assertEqual(node_b.parent, self.root)
        self.assertEqual(node_b.incoming_transition, 1)
        self.assertEqual(list(node_b.children.keys()), [])

    def test_get_known_child(self):
        self.assertEqual(self.root.get_child(0), self.root.children[0])

    def test_get_unknown_child(self):
        self.assertIsNone(self.root.get_child(2))

    def test_add_known_child(self):
        self.assertEqual(self.root.add_child(0), self.root.children[0])

    def test_add_unknown_child(self):
        self.assertEqual(PredictionTree(2, self.root),
                         self.root.add_child(2))
        self.assertEqual(len(self.root.children), 3)

    def test_generate_path_to_root(self):
        self.assertEqual(list(self.node_abc.generate_path_to_root()),
                         [2, 1, 0])

    def test_equal(self):
        tree_1 = PredictionTree()
        tree_1.add_child(0)
        tree_1.add_child(1)
        tree_2 = PredictionTree()
        tree_2.add_child(1)
        tree_2.add_child(0)
        self.assertEqual(tree_1, tree_2)

        tree_2.get_child(1).add_child(2)
        self.assertNotEqual(tree_1, tree_2)
