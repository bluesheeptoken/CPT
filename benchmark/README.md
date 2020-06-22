# Benchmark

## Data
The benchmark has been realized on the [`FIFA`](https://www.philippe-fournier-viger.com/spmf/index.php?link=datasets.php) dataset.

The training has been made with 20_450 sequences with an average length of 34 and an alphabet of 2990 elements.

## Setup
The benchmark has been realized with a PC with 8 GB of ram, 8 cores and the `Intel(R) Core(TM) i7-6700HQ CPU @ 2.60GHz` CPU.

## How to run the code
You can get the data with `curl`: `curl http://www.philippe-fournier-viger.com/spmf/datasets/FIFA.txt --output FIFA.dat`.

With `FIFA.dat` in the data folder, you can run the becnhmark from the root folder: `python benchmark/benchmark.py`.

## Results
Using multithreading, `CPT` made 4869 predictions per second, which is an average of 0.2 ms per prediction.

However, most use case does not take advantage of multithreading. Without multithreading, `CPT` made 1662 predictions per second, which is an average of 0.6ms per prediction.
