# CPT

## Tests
```
python -m unittest discover -p "*Test.py"
```

## Linter
```
pylint cpt
pycodestyle cpt
pylint tests
pycodestyle tests
pylint profiling.py
pycodestyle profiling.py
```

## Source
http://www.philippe-fournier-viger.com/ADMA2013_Compact_Prediction_trees.pdf

## Data
To download data, you will need to install lfs git extension

## 	Profiling
### Run profiling
To run the profiling, you need to run the command `python profiling.py <mode> <data_path> <output_path>`

The mode should be either train or predict

The train profiles are made with the full datasets, and the predict profile are made with the partial datasets

### Read stats
To read stats you need to use the [pstats](https://docs.python.org/3/library/profile.html) module in python. `python -m pstats <profile_path>`
