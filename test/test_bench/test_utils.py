# This file can be populated with various utility functions for testing purposes
import utils
from cocotb.triggers import Timer, RisingEdge

# Empty class that stores input signal and delay after setting
class SampleSignals:
    def __init__(self, val, delay = 1):
        self.val = val
        self.delay = delay

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

# Get a alias-signal dictionary out of signals.yaml
def get_signals(name, sig_type):
    return utils.load_yaml('./../../signals.yaml')[name][sig_type]

class test_module:

    def __init__(self, module_name, dut):
        # Set the module name found in signals.yaml here
        self.name = module_name
        self.dut = dut
        self.input_signals = get_signals(self.name, 'inputs')
        self.output_signals = get_signals(self.name, 'outputs')

        # List of functions or lambdas to that enables additional checks
        self.checkers = list()

        # An function that massages the outputs of the DUT 

        # Holds the current input to the model
        self.curr_input = dict()

    # This function can be used to populate with functions/lambdas for assertions
    # The assertions can be module level or pertaining to internal elements
    def checker(self) -> bool:
        if self.checkers:
            return all(self.checkers)
        else:
            return True

    # This function massages output of the module to be like the model
    def module_out(self) -> bool:
        return self.dut.sum.value

    # This function automates input routine for the DUT
    async def set_input(self, input_dict: dict):
        # Calculate longest input string
        max_len = 0
        for values in input_dict.values():
            temp = len(values)
            if  temp > max_len:
                max_len = temp
        
        # We set the input to the module defined by the
        # input_dict dictionary. The inputs is stored in order
        # to pass to the model for comparison
        for i in range(max_len):
            for sig in input_dict.keys():
                vals = input_dict[sig]
                if i <= len(vals):
                    # Execute the following expression
                    exec(f'self.dut.{self.input_signals[sig]}.value = {vals[i]}')
                    # Retrieves the current input to be passed to the model
                    self.curr_input[sig] = vals[i]

            # Delay after each input
            await Timer(3, 'ns')
    
    # This function compares the DUT against the model
    async def model_compare(self):
        # Import model
        exec(f'from {self.name}_model import {self.name}_model')
        while True:
            await RisingEdge(self.dut.CLK)
            await Timer(1, "ns")

            # Model compare statements
            hardware_output = self.module_out()
            model_output = eval(f'{self.name}_model(**self.curr_input)')

            # Additional conditions to be checked
            assert self.checker(), 'Checker failed!'

            assert hardware_output == model_output, f'HDL-Model output mismatch!\nHardware output: {hardware_output}\nModel output: {bin(model_output)}\n'