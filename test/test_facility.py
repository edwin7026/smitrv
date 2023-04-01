# This file is the top level file of the module-level testing framework
import cocotb_test.simulator
import consts
import utils

'''
This function verilates and runs the various tests provided in module variable
'''
def test_runner():

    # For each module name mentioned in test_list.yaml, if it's set to true
    # it compiles and runs the tests with the corresponding test file
    for module_name, val in utils.load_yaml('./test_list.yaml')['tests'].items():
        if val:
            top_hw_file = module_name + '.v'        # Name of top level verilog file
            top_module_name = module_name           # Name of top level module

            # Run the test
            cocotb_test.simulator.run (
                simulator='verilator',
                verilog_sources = [consts.hardware_path + top_hw_file],
                toplevel_lang = 'verilog',
                toplevel = top_module_name,
                python_search = [consts.model_path, consts.test_root],
                module=f'test_bench.test_{module_name}',
                extra_env = consts.cocotb_env,
                work_dir = consts.work_dir,
                sim_build = consts.sim_build,
                waves = consts.WAVES
            )