# distutils: language = c++
# distutils: sources = decoding.cpp
# distutils: extra_compile_args = -std=c++11

from libcpp.vector cimport vector
from libcpp cimport bool as cbool
from libc.math cimport fabs

cdef extern from "decoding.h":
    cdef void c_chu_liu_edmonds(
            vector[cbool] *disabled,
            vector[vector[int]] *candidate_heads,
            vector[vector[double]] *candidate_scores,
            vector[int] *heads,
            double *value);


def chu_liu_edmonds(score_matrix, tol=0.00001):
    """

    :param score_matrix: an N by N matrix where the i,j-th cell is the score
        of i having j as a head. Index 0 is the artificial root node.
    :param tol: Ignore scores that are closer than tol to zero.
    :return:
    """
    # The size of the sentence includes the root at index 0
    cdef size_t sentence_len = len(score_matrix)
    cdef vector[vector[int]] candidate_heads
    cdef vector[vector[double]] candidate_scores
    cdef double ctol = tol
    cdef vector[int] heads = vector[int](sentence_len, -1)
    cdef vector[cbool] disabled = vector[cbool](sentence_len, <cbool> False)
    cdef double tree_score = 0

    candidate_scores.resize(sentence_len)
    candidate_heads.resize(sentence_len)

    assert len(score_matrix.shape) == 2, "Score matrix must be 2-dim"
    assert score_matrix.shape[0] == score_matrix.shape[1], "Score matrix must be square"

    cdef int dep_i, head_i
    cdef double edge_score
    for dep_i in range(1, score_matrix.shape[0]):
        for head_i in range(score_matrix.shape[1]):
            edge_score = score_matrix[dep_i, head_i]
            if fabs(edge_score) > ctol:
                candidate_heads[dep_i].push_back(head_i)
                candidate_scores[dep_i].push_back(edge_score)


    c_chu_liu_edmonds(disabled=&disabled, candidate_heads=&candidate_heads, candidate_scores=&candidate_scores,
                    heads=&heads, value=&tree_score)

    # Convert heads format
    return heads, tree_score