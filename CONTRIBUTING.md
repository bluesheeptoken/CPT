# Guidelines

To compile, cython needs to be installed.

## Tests
### Run tests
Pytest is used for tests.

`make test`

## Linter
pycodestyle and pylint are used for linter.

`make lint`

## Sources

## Data
### Files
The main dataset used to profile is FIFA, stream data from the website of FIFA World Cup 98. Can be download [here](http://www.philippe-fournier-viger.com/spmf/index.php?link=datasets.php)

## Profiling

### Run profiling
To run the profiling, you need to run the command `python profiling/profiling.py <mode> <data_path> <profile_path>`.

For instance, `python profiling/profiling.py train data/FIFA.dat profiling/sample_profiling.profile`.

The mode should be either train or predict.

The train profiles should be made with the full datasets, the predict profiles should be made with the partial datasets. The `predict` method is taking more time than the `train` method, so a smaller dataset is enough to profile `predict`.

### Read stats
To read stats you need to use the [pstats](https://docs.python.org/3/library/profile.html) module. `python -m pstats <profile_path>`.

## Before pushing
Make sure you ran `make test` and `make lint` before pushing.
