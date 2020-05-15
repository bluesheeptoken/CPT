Examples
========

Hello World example
-------------------

You can test the model with the following code

.. code-block:: python3

    from cpt import Cpt
    model = Cpt()

    model.fit([['hello', 'world'],
               ['hello', 'this', 'is', 'me'],
               ['hello', 'me']
              ])

    model.predict([['hello'], ['hello', 'this']])
    # Output: ['me', 'is']


Sklearn Example
---------------

This code is also compatible with sklearn tools such as ``Gridsearch``

.. code-block:: python3

    from sklearn.base import BaseEstimator
    from cpt import Cpt
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
