import numpy as np
from dependency_decoding import chu_liu_edmonds

np.random.seed(43)
score_matrix = np.random.rand(3, 3)
heads, tree_score = chu_liu_edmonds(score_matrix)
print(score_matrix)
print(heads, tree_score)