# CPT

[![Downloads](https://img.shields.io/pypi/dm/CPT)](https://img.shields.io/pypi/dm/CPT)
[![License](https://img.shields.io/pypi/l/cpt.svg)](https://github.com/bluesheeptoken/CPT/blob/master/LICENSE)

## What is it ?

This project is a cython open-source implementation of the Compact Prediction Tree algorithm using multithreading.

CPT is a sequence prediction model. It is a highly explainable model specialized in predicting the next element of a sequence over a finite alphabet.

This implementation is based on the following research papers:

- http://www.philippe-fournier-viger.com/ADMA2013_Compact_Prediction_trees.pdf
- http://www.philippe-fournier-viger.com/spmf/PAKDD2015_Compact_Prediction_tree+.pdf

## Installation

You can simply use `pip install cpt`.

## Simple example

You can test the model with the following code:

```python
from cpt.cpt import Cpt
model = Cpt()

model.fit([['hello', 'world'],
           ['hello', 'this', 'is', 'me'],
           ['hello', 'me']
          ])

model.predict([['hello'], ['hello', 'this']])
# Output: ['me', 'is']
```
For an example with the compatibility with sklearn, you should check the [documentation][1].

## Features
### Train

The model can be trained with the `fit` method.

If needed the model can be retrained with the same method. It adds new sequences to the model and do not remove the old ones.

### Multithreading

The predictions are launched by default with multithreading with OpenMP.

The predictions can also be launched in a single thread with the option `multithread=False` in the `predict` method.

You can control the number of threads by setting the following environment variable `OMP_NUM_THREADS`.

### Pickling

You can pickle the model to save it, and load it later via pickle library.
```python
from cpt.cpt import Cpt
import pickle


model = Cpt()
model.fit([['hello', 'world']])

dumped = pickle.dumps(model)

unpickled_model = pickle.loads(dumped)

print(model == unpickled_model)
```

### Explainability

The CPT class has several methods to explain the predictions.

You can see which elements are considered as `noise` (with a low presence in sequences) with `model.compute_noisy_items(noise_ratio)`.

You can retrieve trained sequences with `model.retrieve_sequence(id)`.

You can find similar sequences with `find_similar_sequences(sequence)`.

You can not yet retrieve automatically all similar sequences with the noise reduction technique.

### Tuning

CPT has 3 meta parameters that need to be tuned. You can check how to tune them in the [documentation][1]. To tune you can use the `model_selection` module from `sklearn`, you can find an example [here][3] on how to.

## Benchmark

The benchmark has been made on the FIFA dataset, the data can be found on the [SPMF website][4].

Using multithreading, `CPT` was able to perform around 5000 predictions per second.

Without multithreading, `CPT` predicted around 1650 sequences per second.

Details on the benchmark can be found [here](benchmark).

## Further reading

A study has been made on how to reduce dataset size, and so training / testing time using PageRank on the dataset.

The study has been published in IJIKM review [here][5]. An overall performance improvement of 10-40% has been observed with this technique on the prediction time without any accuracy loss.

[1]: https://cpt.readthedocs.io/en/latest/
[2]: https://github.com/bluesheeptoken/CPT#tuning
[3]: https://cpt.readthedocs.io/en/latest/example.html#sklearn-example
[4]: https://www.philippe-fournier-viger.com/spmf/index.php?link=datasets.php
[5]: http://www.ijikm.org/Volume14/IJIKMv14p027-044Da5395.pdf
