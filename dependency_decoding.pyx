# distutils: language = c++
# distutils: sources = decoding.cpp
# distutils: extra_compile_args = -std=c++11

from libcpp.vector cimport vector
from libcpp cimport bool as cbool

cdef extern from "decoding.h":
    cdef void c_chu_liu_edmonds(
            vector[cbool] *disabled,
            vector[vector[int]] *candidate_heads,
            vector[vector[double]] *candidate_scores,
            vector[int] *heads,
            double *value);

def chu_liu_edmonds(score_matrix, tol=0.00001):
    # The size of the sentence includes the root at index 0
    cdef size_t sentence_len = len(score_matrix) + 1
    cdef vector[vector[int]] candidate_heads
    cdef vector[vector[double]] candidate_scores
    cdef double ctol = tol
    cdef vector[int] heads = vector[int](sentence_len, -1)
    cdef vector[cbool] disabled = vector[cbool](sentence_len, <cbool> False)
    cdef double tree_score = 0

    candidate_scores.resize(sentence_len)
    candidate_heads.resize(sentence_len)

    assert len(score_matrix.shape) == 2, "Score matrix must be 2-dim"

    cdef int dep_i, head_i, root_i
    cdef double edge_score
    root_i = score_matrix.shape[1] - 1
    for dep_i in range(score_matrix.shape[0]):
        for head_i in range(score_matrix.shape[1]):
            edge_score = score_matrix[dep_i, head_i]
            if edge_score > ctol:
                candidate_heads[dep_i + 1].push_back(head_i + 1 if head_i != root_i else 0)
                candidate_scores[dep_i + 1].push_back(edge_score)


    c_chu_liu_edmonds(disabled=&disabled, candidate_heads=&candidate_heads, candidate_scores=&candidate_scores,
                    heads=&heads, value=&tree_score)

    # Convert heads format
    converted_heads = []
    for i in range(1, len(heads)):
        converted_heads.append(heads[i] - 1)

    return converted_heads, tree_score