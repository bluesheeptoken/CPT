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
pylint profiling
pycodestyle profiling
```

## Sources
http://www.philippe-fournier-viger.com/ADMA2013_Compact_Prediction_trees.pdf
																																																																																																																																																																												
http://www.philippe-fournier-viger.com/spmf/PAKDD2015_Compact_Prediction_tree+.pdf

## Data
To download data, you will need to install lfs git extension

## Profiling
### Run profiling
To run the profiling, you need to run the command `python profiling/profiling.py --mode <mode> --data_path <data_path> --profile_path <profile_path>`

For instance, `python profiling/profiling.py --mode train --data_path data/FIFA.dat --profile_path profiling/sample_profiling.profile`

The mode should be either train or predict

The train profiles should be made with the full datasets, the predict profiles should be made with the partial datasets. The `predict` method is taking more time than the `train` method, so a smaller dataset is enough to profile `predict` 

### Read stats
To read stats you need to use the [pstats](https://docs.python.org/3/library/profile.html) module in python. `python -m pstats <profile_path>`
