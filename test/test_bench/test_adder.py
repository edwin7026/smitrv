import cocotb
from cocotb.triggers import Timer
import utils
import test_utils

# Import the model
from adder_model import adder_model

# This function continuously updates CLK
async def generate_clock(sim_len, dut):
    '''
    Generate clock pulses
    Argument:
        sim_len: Number of cycles
        dut: cocotb dut
    '''
    for cycle in range(sim_len):
        dut.CLK.value = 0
        await Timer(1, units="ns")
        dut.CLK.value = 1
        await Timer(1, units="ns")

class test_module:

    # Sim length
    SIM_NUM_CYCLES = 30

    # Set the module name found in signals.yaml here
    name = 'adder'

    def __init__(self, dut):
        self.dut = dut
        self.input_signals = test_utils.get_signals('adder', 'inputs')

    async def set_input(self, input_dict: dict):
        # For iteration
        i = 0
    
        # Holds the current input to the model
        curr_input = dict()

        # We set the input to the module defined by the
        # input_dict dictionary. The inputs is stored in order
        # to pass to the model for comparison
        for values in input_dict.values():
            for sig in input_dict.keys():
                if i < len(values):
                    # Execute the following expression
                    exec(f'self.dut.{self.input_signals[sig]}.value = {values[i]}')
                    # Retrieves the current input to be passed to the model
                    curr_input[sig] = values[i]

            # Additional conditions to be checked
            assert self.checker(), 'Checker failed!'
            
            # Model compare statements
            assert self.module_out() == adder_model(self.dut.CLK.value, **curr_input), 'HDL-Model output mismatch!'
            
            # Await till some time before next input is fed
            await Timer(1, units='ns')

            i = i + 1               # increment value index
    
    # This function can be used to populate with lambdas for assertions
    # The assertions can be module level or pertaining to internal elements
    def checker(self) -> bool:
        pass

    # This function massages output of the module to be like the model
    def module_out(self) -> bool:
        return self.dut.sum.value

# This decorator spawns a cocotb.test instance for co-simulation
@cocotb.test()
async def test_top(dut):
    '''
    This async function tests the adder dut against the python model
    '''

    # Concurrently gets the clock ticking
    await cocotb.start(generate_clock(test_module.SIM_NUM_CYCLES, dut))

    sig = test_module(dut)

    # Input signals
    sig_val = {
        'A' : [1, 2, 3],
        'B' : [1, 2, 3]
    }
    
    # Automate inputs setting and run tests
    await cocotb.start(sig.set_input(sig_val))