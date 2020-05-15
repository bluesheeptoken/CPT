#!/usr/bin/env bash
set -e

if [ "$TRAVIS_OS_NAME" = 'linux' ]; then
    exit 0;
fi

umask 022;
chmod -R a+rX .;
brew install llvm libomp;
export CPP=/usr/local/opt/llvm/bin/clang;
export PATH="/usr/local/opt/llvm/bin:$PATH";
REQUIRED_PYTHON_VERSION=$(python -c "import os; toxenv = os.environ['TOXENV']; print('.'.join(list(toxenv[2:])))");
brew install sashkab/python/python@$REQUIRED_PYTHON_VERSION
/usr/local/opt/python@$REQUIRED_PYTHON_VERSION/bin/python$REQUIRED_PYTHON_VERSION -mvenv venv
source venv/bin/activate

pip install -U "pip < 19.2" "wheel==0.34.2" twine cython
python setup.py sdist

if [ -d build ]; then find build -name '*.py[co]' -delete; fi
python setup.py build_ext
python setup.py build --executable '/usr/bin/env python'
python    -m compileall build
python -O -m compileall build
python setup.py bdist_wheel

v=$(python -c "import sys; print(''.join(sys.version.split('.')[:2]))")

pip install -U delocate

for f in dist/cpt-*-cp$v-*-macosx*.whl; do
    delocate-wheel -v "$f"
done

# TWINE_USERNAME / TWINE_PASSWORD / TWINE_REPOSITORY_URL
# must be set in Travis settings.


twine upload --skip-existing dist/* -u $TWINE_USERNAME -p $TWINE_PASSWORD -r $TWINE_REPOSITORY_URL
