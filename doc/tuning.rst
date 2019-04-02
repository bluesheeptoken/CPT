Tuning
======
CPT has 3 meta parameters that need to be tuned

MBR
---

MBR indicates the number of similar sequences that need to be found before predicting a value.

The higher this parameter, the longer the prediction. Having more similar sequences can result in a higher accuracy.

split_length
------------

split_length is the number of elements per sequence to be stored in the model. (Choosing 0 results in taking all elements)

split_length needs to be finely tuned. As the model cannot predict an element present in the sequence, giving a too long sequence might result in lower accuracy.

noise_ratio
-----------

The noise_ratio determines which elements are defined as noise and should not be taken into account.
