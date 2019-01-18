import unittest

from cpt.scorer import Scorer


class ScorerTest(unittest.TestCase):

    def test_update(self):
        # GIVEN
        scorer = Scorer(3)
        expected = [2, 0, 1]

        # WHEN
        scorer.update(0)
        scorer.update(0)
        scorer.update(2)

        # THEN
        self.assertEqual(scorer.scoring, expected)

    def test_predictable(self):
        scorer = Scorer(3)
        self.assertFalse(scorer.predictable())

        scorer.update(0)
        self.assertTrue(scorer.predictable())

    def test_get_best_prediction(self):
        scorer = Scorer(3)
        scorer.update(0)
        scorer.update(0)
        scorer.update(2)
        self.assertEqual(scorer.get_best_prediction(), 0)

    def test_get_best_predictions(self):
        scorer = Scorer(3)
        scorer.update(0)
        scorer.update(0)
        scorer.update(2)
        self.assertEqual(scorer.get_best_predictions(2), [0, 2])

