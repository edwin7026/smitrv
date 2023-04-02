# This file contains a python implementation of of a full adder for
# module level verification. We consider this to be a reference model

'''
Clock enabled adder model
Arguments:
    A (int), B(int) : Inputs to the adder
    CLK (bool)      ; Clock Pulse
Returns
    (int)           : Sum of A and B
'''
def adder_model(CLK: bool, A: int, B: int) -> int:
    try:
        if adder_model.clk < CLK:   # positive edge
            adder_model.sum = A + B
            return adder_model.sum
        else:
            return adder_model.sum
    except AttributeError:          # initial run
        adder_model.clk = CLK
        adder_model.sum = 0
        return adder_model.sum

# Module debugging
if __name__ == '__main__':

    # Model testing

    print(adder_model(0, 3, 4))
    print(adder_model(0, 3, 4))
    print(adder_model(0, 3, 4))
    print(adder_model(1, 3, 4))
    print(adder_model(1, 3, 4))
    print(adder_model(0, 4, 4))
    print(adder_model(1, 4, 4))