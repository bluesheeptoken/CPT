upload_wheels() {
  pwd
  ls -l
  python3 -m pip install twine
  if [[ $TRAVIS_TAG ]]; then
    python3 -m pip install twine
    python3 -m twine upload ./wheelhouse/*.whl
  fi
}