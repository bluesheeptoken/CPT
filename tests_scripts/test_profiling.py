import json
import pstats
import unittest
import tempfile

from profiling import profiling


def check_called_method(profile, method_name):
    return any(map(lambda x: x[2] == method_name, profile.strip_dirs().stats.keys()))


class ProfilingTest(unittest.TestCase):

    def test_train_dat(self):
        with tempfile.NamedTemporaryFile() as data:
            data.write(b'0 1 2 3 4 5 6')
            data.flush()
            with tempfile.NamedTemporaryFile() as file:
                profiling.profile('train', data.name, file.name)
                profile = pstats.Stats(file.name)
                # Train should call add_symbol if everything goes well
                self.assertTrue(check_called_method(profile, 'add_symbol'))

    def test_predict_json(self):
        with tempfile.NamedTemporaryFile('r+', suffix='.json') as data:
            json.dump({'id': list('abcdefghijkl')}, data)
            data.flush()
            with tempfile.NamedTemporaryFile() as file:
                profiling.profile('predict', data.name, file.name)
                profile = pstats.Stats(file.name)
                self.assertTrue(check_called_method(profile, '_find_similar_sequences'))
