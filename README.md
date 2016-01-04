## Chu-Liu-Edmonds dependency decoding

This package wraps the Chu-Liu-Edmonds maximum spanning algorithm from TurboParser for use within Python.
 
It provides a function `chu_liu_edmonds` which accepts a $N \times N+1$ score matrix as argument.
The $i,j$-th cell is the score for the edge j->i. In other words, a row gives the scores for the different heads of a dependent.

Scores for root attachment are placed in the final column. Attachments to root are reported as `-1`. 
 
Example usage:

```
import numpy as np
from dependency_decoding import chu_liu_edmonds

np.random.seed(42)
score_matrix = np.random.rand(3, 4)
heads, tree_score = chu_liu_edmonds(score_matrix)
print(heads, tree_score)
```