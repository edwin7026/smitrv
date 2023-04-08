import cocotb
from cocotb.triggers import Timer

# Get test utilities
from test_bench.test_utils import test_module, generate_clock

# Sim length
SIM_NUM_CYCLES = 100

# This decorator spawns a cocotb.test instance for co-simulation
@cocotb.test()
async def test_top(dut):
    '''
    This async function tests the adder dut against the python model
    '''

    # Concurrently gets the clock ticking
    await cocotb.start(generate_clock(SIM_NUM_CYCLES, dut))

    # Initiate test
    adder_test = test_module('adder', dut)

    # Input signals
    sig_val = {
        'A' : [1, 2, 3, 2, 5],
        'B' : [4, 5, 6, 1, 8]
    }

    # Add checkers
    checkers_lst = [

    ]
    
    # Automate setting inputs parallely
    await cocotb.start(adder_test.set_input(sig_val))

    # Concurrently compare DUT against model
    await cocotb.start(adder_test.model_compare())

    # await till the simulation finishes
    await Timer(2 * SIM_NUM_CYCLES, units='ns')