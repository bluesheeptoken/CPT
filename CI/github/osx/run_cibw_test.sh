#!/bin/sh
set -e
mkdir -p tmp_for_test
cp -r {project}/tests tmp_for_test
pytest tmp_for_test/tests
