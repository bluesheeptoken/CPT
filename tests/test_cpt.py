import unittest
import pickle

from cpt import Cpt  # pylint: disable=no-name-in-module
from cpt.alphabet import Alphabet


class CptTest(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        cls.cpt = Cpt()

        cls.sequences = [['A', 'B', 'C'],
                         ['A', 'B'],
                         ['A', 'B', 'D'],
                         ['B', 'C', 'D'],
                         ['B', 'D', 'E']]

        cls.cpt.fit(cls.sequences)

    def test_init(self):
        with self.assertRaises(ValueError):
            Cpt(-5)

    def test_fit(self):
        alphabet = Alphabet()
        alphabet.length = 5
        alphabet.indexes = {'A': 0, 'B': 1, 'C': 2, 'D': 3, 'E': 4}
        alphabet.symbols = ['A', 'B', 'C', 'D', 'E']
        self.assertEqual(self.cpt.alphabet.length, alphabet.length)
        self.assertEqual(self.cpt.alphabet.indexes, alphabet.indexes)
        self.assertEqual(self.cpt.alphabet.symbols, alphabet.symbols)

    def test_predict(self):
        old_noise_ratio = self.cpt.noise_ratio
        old_MBR = self.cpt.MBR

        self.cpt.noise_ratio = 1
        self.cpt.MBR = 3
        self.assertEqual(self.cpt.predict([['A'], ['A', 'B']]), ['B', 'D'])
        # Test if predictions are the same with multi threading turned off
        self.assertEqual(self.cpt.predict([['A'], ['A', 'B']], False), ['B', 'D'])

        self.cpt.MBR = 2
        self.assertEqual(self.cpt.predict([['A', 'B']]), ['C'])

        self.cpt.noise_ratio = 0.2
        self.cpt.MBR = 1
        self.assertEqual(self.cpt.predict([['B', 'D', 'E']]), ['E'])
        # Default value is the first of the alphabet
        self.cpt.noise_ratio = 0.1
        self.assertEqual(self.cpt.predict([['B', 'D', 'E']]), ['A'])

        # Check value raises
        # noise_ratio should be <= 1.0
        self.cpt.noise_ratio = 1.1
        with self.assertRaises(ValueError):
            self.cpt.predict([[]])
        # noise ratio should be >= 0
        self.cpt.noise_ratio = -0.2
        with self.assertRaises(ValueError):
            self.cpt.predict([[]])
        # MBR should be >= 0
        self.cpt.MBR = -5
        with self.assertRaises(ValueError):
            self.cpt.predict([[]])

        self.cpt.noise_ratio = old_noise_ratio
        self.cpt.MBR = old_MBR

    def test_richcmp(self):
        cpt_wrong_split_length = Cpt(1)
        cpt_wrong_split_length.fit(self.sequences)
        self.assertNotEqual(self.cpt, cpt_wrong_split_length)
        self.assertEqual(self.cpt, self.cpt)

    def test_pickle(self):
        pickled = pickle.dumps(self.cpt)
        unpickled_cpt = pickle.loads(pickled)
        self.assertEqual(self.cpt, unpickled_cpt)

    def test_refit(self):
        '''
        The bitset is coded on 8 bits,
        we need to train with at least 9 sequences to test the resize method
        '''
        model_no_retrain = Cpt()
        model_no_retrain.fit([['C', 'P', 'T', '1'],
                              ['C', 'P', 'T', '2'],
                              ['C', 'P', 'T', '3'],
                              ['C', 'P', 'T', '4'],
                              ['C', 'P', 'T', '5'],
                              ['C', 'P', 'T', '6'],
                              ['C', 'P', 'T', '7'],
                              ['C', 'P', 'T', '8'],
                              ['C', 'P', 'T', '9']
                             ])

        model_with_retrain = Cpt()
        model_with_retrain.fit([['C', 'P', 'T', '1'],
                                ['C', 'P', 'T', '2'],
                                ['C', 'P', 'T', '3'],
                                ['C', 'P', 'T', '4'],
                                ['C', 'P', 'T', '5'],
                                ['C', 'P', 'T', '6'],
                                ['C', 'P', 'T', '7'],
                                ['C', 'P', 'T', '8']
                               ])
        model_with_retrain.fit([['C', 'P', 'T', '9']])

        self.assertEqual(model_no_retrain, model_with_retrain)

    def test_compute_noisy_items(self):
        self.assertEqual(self.cpt.compute_noisy_items(0.2), ['E'])

    def test_retrieve_sequence(self):
        self.assertEqual(self.cpt.retrieve_sequence(0), ['A', 'B', 'C'])

    def test_find_similar_sequences(self):
        similar_sequences = [['A', 'B', 'C'], ['A', 'B'], ['A', 'B', 'D']]
        self.assertEqual(self.cpt.find_similar_sequences(['A', 'B']), similar_sequences)
