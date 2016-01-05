## Chu-Liu-Edmonds dependency decoding

This package wraps the Chu-Liu-Edmonds maximum spanning algorithm from TurboParser for use within Python.
 
It provides a function `chu_liu_edmonds` which accepts a $N \times N$ score matrix as argument, where N is the sentence length, including the artificial root node.
The $i,j$-th cell is the score for the edge j->i. In other words, a row gives the scores for the different heads of a dependent. 

A `np.nan` cell value informs the algorithm to skip the edge. 
 
Example usage:

```
import numpy as np
from dependency_decoding import chu_liu_edmonds

np.random.seed(42)
score_matrix = np.random.rand(3, 4)
heads, tree_score = chu_liu_edmonds(score_matrix)
print(heads, tree_score)
```