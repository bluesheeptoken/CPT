# CPT

CPT is a cython open-source implementation of the Compact Prediction Tree algorithm using multithreading.

CPT is a sequence prediction algorithm. It is a highly explainable model and good at predicting values in a finite alphabet not already seen in the sequence. (Cf how to tune the "CPT model")

This is an implementation of the following research papers

http://www.philippe-fournier-viger.com/ADMA2013_Compact_Prediction_trees.pdf

http://www.philippe-fournier-viger.com/spmf/PAKDD2015_Compact_Prediction_tree+.pdf

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

class SKCpt(Cpt, BaseEstimator):
    def __init__(self, split_index=0, noise_ratio=0, MBR=0):
        super().__init__(split_index)
        self.noise_ratio = noise_ratio
        self.MBR = MBR

    def predict(self, sequences):
        return super().predict(sequences, self.noise_ratio, self.MBR)

    def score(self, X):
        predictions = self.predict(list(map(lambda x: x[self.split_index:-1], X)))
        score = sum([predictions[i] == X[i][-1] for i in range(len(X))]) / len(X) * 100
        return score

data = [['hello', 'world'], ['hello', 'cpt']]


from sklearn.grid_search import GridSearchCV

tuned_params = {'MBR': [0, 5], 'split_index': [0, 1, 5]}

gs = GridSearchCV(SKCpt(), tuned_params)

gs.fit(data)
```
You can test it with more data to have more relevant tuning.

## Features
### Train

The model can be trained with the `train` method.

If needed the model can be retrained with the same methods. It adds new sequences to the model and do not remove the old ones.

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
model.fit([['hello', 'world']])

dumped = pickle.dumps(model)

unpickled_model = pickle.loads(dumped)

print(model == unpickled_model)
```

### Explainability

The CPT class has several methods to explain the predictions.

You can see which elements are considered as `noise` (with a low presence in sequences) with `model.compute_noisy_items(noise_ratio)`

You can retrieve trained sequences with `model.retrieve_sequence(id)`

You can find similar sequences with `find_similar_sequences(sequence)`

You can not yet automatically all similar sequences with the noise reduction technique
