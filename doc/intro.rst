Introduction
============

This project is a cython open-source implementation of the Compact Prediction Tree algorithm using multithreading.

CPT is a sequence prediction algorithm. It is a highly explainable model and good at predicting, in a finite alphabet, next value of a sequence. However, given a sequence, CPT cannot predict an element already present in this sequence (Cf "Tuning" part).

This implementation is based on the following research papers

http://www.philippe-fournier-viger.com/ADMA2013_Compact_Prediction_trees.pdf

http://www.philippe-fournier-viger.com/spmf/PAKDD2015_Compact_Prediction_tree+.pdf
