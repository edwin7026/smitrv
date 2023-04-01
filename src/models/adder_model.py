# This file contains a python implementation of of a full adder for
# module level verification. We consider this to be a reference model

'''
Adder model
Arguments:
    A (int), B(int) : Inputs to the adder
Returns
    (int)           : Sum of A and B
'''
def adder_model(A: int, B: int) -> int:
    return A + B