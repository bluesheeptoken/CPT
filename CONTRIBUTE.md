# Guidelines

To compile, cython needs to be installed.

## Tests
### Run tests
Pytest is used for tests.

`make test`

### Generate coverage
To generate coverage, you should use the coverage python module.

For the python code you can use `pytest --cov=cpt tests`.

## Linter
pycodestyle and pylint are used for linter.

`make lint`

## Sources

## Data
### Download files
To download data, you will need to install lfs git extension.

## Profiling
### Add metadata to metadata.json
You should run `python generate_metadata.py <data_path> <datasetname>` from the data directory.

For instance, `python generate_metadata.py FIFA.dat partial_fifa`.

### Run profiling
To run the profiling, you need to run the command `python profiling/profiling.py <mode> <data_path> <profile_path>`.

For instance, `python profiling/profiling.py train data/FIFA.dat profiling/sample_profiling.profile`.

The mode should be either train or predict.

The train profiles should be made with the full datasets, the predict profiles should be made with the partial datasets. The `predict` method is taking more time than the `train` method, so a smaller dataset is enough to profile `predict`.

### Read stats
To read stats you need to use the [pstats](https://docs.python.org/3/library/profile.html) module in python. `python -m pstats <profile_path>`.

## Before pushing
Make sure you ran `make test` and `make lint` before pushing.
