import unittest
import tempfile
import os
import sys

from profiling import profiling
import pstats
import json


class ProfilingTest(unittest.TestCase):

    def check_called_method(self, profile, method_name):
        return [x for x in profile.strip_dirs().stats.keys() if x[2] == method_name]

    def test_train_dat(self):
        with tempfile.NamedTemporaryFile() as data:
            data.write(b'0 1 2 3 4 5 6')
            data.read()  # The file is empty if I do not use any data method
            with tempfile.NamedTemporaryFile() as f:
                profiling.main('train', data.name, f.name)
                p = pstats.Stats(f.name)
                # Train should call add_child if everything goes well
                self.assertTrue(self.check_called_method(p, 'add_child'))

    def test_predict_json(self):
        with tempfile.NamedTemporaryFile('r+', suffix='.json') as data:
            json.dump({'id': list('abcdefghijkl')}, data)
            data.read()  # The file is empty if I do not use any data method
            with tempfile.NamedTemporaryFile() as f:
                profiling.main('predict', data.name, f.name)
                p = pstats.Stats(f.name)
                self.assertTrue(self.check_called_method(p, '_find_similar_sequences'))

