# CPT

CPT is a cython open-source implementation of the Compact Prediction Tree algorithm using multithreading.

This is an implementation of the following research papers

http://www.philippe-fournier-viger.com/ADMA2013_Compact_Prediction_trees.pdf

http://www.philippe-fournier-viger.com/spmf/PAKDD2015_Compact_Prediction_tree+.pdf

## Simple example

You can test the model with the following code

```python
from cpt.cpt import Cpt
model = Cpt()

model.train([['hello', 'world'],
             ['hello', 'this', 'is', 'me'],
             ['hello', 'me']
            ])

model.predict([['hello'], ['hello', 'this']])
# Output: ['me', 'is']
```

## Features
### Train

The model can be trained with the `train` method.

If needed the model can be retrained with the same methods. It adds new sequences to the model but do not remove the old ones.

### Multithreading

The predictions are launched by default with multithreading with OpenMP.

The predictions can also be launched in a single thread with the option `multithread=False` in the `predict` method.

By default the number of threads equals the number of cores, you can control it by setting the following environment variable `OMP_NUM_THREADS`.

### Pickling

You can pickle the model to save it, and load it later via pickle library.
```python
from cpt.cpt import Cpt
import pickle


model = Cpt()
model.train([['hello', 'world']])

dumped = pickle.dumps(model)

unpickled_model = pickle.loads(dumped)

print(model == unpickled_model)
```
