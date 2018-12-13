import unittest

from compiled.hello import hello


class CptTest(unittest.TestCase):
    def test_hello(self):
        # GIVEN
        expected = 2

        # WHEN
        actual = hello()

        # THEN
        self.assertEqual(actual, expected)
