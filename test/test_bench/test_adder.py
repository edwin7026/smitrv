import cocotb
from cocotb.triggers import Timer
import utils

# Import the model
from adder_model import adder_model

class Signals:

    # Set the module name found in signals.yaml here
    module_name = 'adder'

    # Signal types for probing
    sig_types = ['outputs']

    def __init__(self, dut):
        signals = utils.load_yaml('./signals.yaml')[Signals.module_name]
        for types in Signals.sig_types:
            for alias, signal in signals[types]:
                setattr(self, alias, getattr(dut, signal))

# This decorator spawns a cocotb.test instance for co-simulation
@cocotb.test()
async def adder_basic_test(dut):
    '''
        This async function tests the adder dut against the python model
    '''

    A = 5
    B = 10
        
    dut.A.value = A
    dut.B.value = B

    await Timer(2, units = "ns")

    assert dut.Sum.value == adder_model(A, B), 'Adder result is incorrect!'