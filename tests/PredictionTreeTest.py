import unittest

from cpt.PredictionTree import PredictionTree


class PredictionTreeTest(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        cls.predictionTree = PredictionTree()
        cls.predictionTree.add_child("A")
        cls.predictionTree.get_child("A").add_child("B")
        cls.predictionTree.get_child("A").get_child("B").add_child("C")
        cls.predictionTree.add_child("B")

    def test_has_child(self):
        """[has_child] check if child is in node"""
        self.assertTrue(self.predictionTree.has_child("A"))

        self.assertFalse(self.predictionTree.has_child("C"))

    def test_retrieve_path_from_root(self):
        # GIVEN
        expected = ["A", "B", "C"]

        # WHEN
        actual = self.predictionTree \
            .get_child("A") \
            .get_child("B") \
            .get_child("C") \
            .retrieve_path_from_root()


        # THEN
        self.assertEqual(actual, expected)

    def test_get_child(self):
        self.assertIsNone(self.predictionTree.get_child("not a child"))

        self.assertEqual(self.predictionTree.get_child("A").item, "A")
