#!/usr/bin/env bash
set -e

umask 022
chmod -R a+rX .

pip3 install -U pip setuptools "wheel==0.31.1" twine
python3 setup.py sdist

if [ -d build ]; then find build -name '*.py[co]' -delete; fi
python3 setup.py build_ext
python3 setup.py build --executable '/usr/bin/env python3'
python3    -m compileall build
python3 -O -m compileall build
python3 setup.py bdist_wheel

v=$(python3 -c "import sys; print(''.join(sys.version.split('.')[:2]))")

# if [ "$TRAVIS_OS_NAME" = "linux" ]; then
#     pip3 install -U auditwheel

#     for f in dist/cpt-*-cp$v-*-linux_x86_64.whl; do
#         python3 -m auditwheel repair -w dist/ "$f"
#         rm -f "$f"
#     done

if [ "$TRAVIS_OS_NAME" = "osx" ]; then
    pip3 install -U delocate

    for f in dist/cpt-*-cp$v-*-macosx*.whl; do
        delocate-wheel -v "$f"
    done
fi

# TWINE_USERNAME / TWINE_PASSWORD / TWINE_REPOSITORY_URL
# must be set in Travis settings.
twine upload --skip-existing dist/* -u $TWINE_USERNAME -p $TWINE_PASSWORD -r $TWINE_REPOSITORY_URL
