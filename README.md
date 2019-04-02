# CPT

This project is a cython open-source implementation of the Compact Prediction Tree algorithm using multithreading.

CPT is a sequence prediction algorithm. It is a highly explainable model and good at predicting, in a finite alphabet, next value of a sequence. However, given a sequence, CPT cannot predict an element already present in this sequence (Cf how to tune the "CPT model").

This implementation is based on the following research papers

http://www.philippe-fournier-viger.com/ADMA2013_Compact_Prediction_trees.pdf

http://www.philippe-fournier-viger.com/spmf/PAKDD2015_Compact_Prediction_tree+.pdf

## Installation

To use this project, you need to install it locally. You will need to compile cython sources.

The wheels will be soon published on Pypi.

## Simple example

You can test the model with the following code

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

## Sklearn Example

CPT is compatible with `sklearn`, you can, for instance, use GridSearch on it.
```python
from sklearn.base import BaseEstimator
from cpt.cpt import Cpt
from sklearn.model_selection import GridSearchCV


class SKCpt(Cpt, BaseEstimator):
    def __init__(self, split_length=0, noise_ratio=0, MBR=0):
        super().__init__(split_length, noise_ratio, MBR)

    def score(self, X):
        # Choose your own scoring function here
        predictions = self.predict(list(map(lambda x: x[self.split_length:-1], X)))
        score = sum([predictions[i] == X[i][-1] for i in range(len(X))]) / len(X) * 100
        return score

data = [['hello', 'world'], ['hello', 'cpt'], ['hello', 'cpt']]


tuned_params = {'MBR': [0, 5], 'split_length': [0, 1, 5]}

gs = GridSearchCV(SKCpt(), tuned_params)

gs.fit(data)

gs.cv_results_
```
You can test it with more data to have a more relevant tuning.

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

CPT has 3 meta parameters that need to be tuned

#### MBR

MBR indicates the number of similar sequences that need to be found before predicting a value.

The higher this parameter, the longer the prediction. Having more similar sequences can result in a higher accuracy.

#### split_length

split_length is the number of elements per sequence to be stored in the model. (Choosing 0 results in taking all elements)

split_length needs to be finely tuned. As the model cannot predict an element present in the sequence, giving a too long sequence might result in lower accuracy.

#### noise_ratio

The noise_ratio determines which elements are defined as noise and should not be taken into account.
