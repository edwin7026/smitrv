# This file contains important constants for the framework

import os

# Absolute path to the src directory
root_path = os.path.abspath(os.path.dirname(__file__) + '/../')

# Important paths
hardware_path = root_path + '/src/hardware/'
model_path = root_path + '/src/models/'

test_root = root_path + '/test/'
test_file_dir = test_root + '/test_bench/'
sim_build = test_root + '/sim_build/'

# Paths to signal and test_list YAMLs
test_list_path = root_path + '/test/test_list.yaml'
signals_path = root_path + '/test/signals.yaml'

# Environment variables to be set

# Set this to True if .fst file required for generating
# the waveform is to be generated
WAVES = True

cocotb_env = {
    # Add the test modules to PYTHONPATH
    'PYTHONPATH'             : f'${{PYTHONPATH}}:{test_file_dir}',

    # This path needs to be set individually
    # Please do a `locate libpython3.10.so`
    # Choose a path that leads to libpython3.10.so and replace the following with that
    'LIBPYTHON_LOC'          : '/snap/gnome-42-2204/65/usr/lib/x86_64-linux-gnu/libpython3.10.so',
    
    # These environment variables dictate cocotb logging settings
    'COCOTB_REDUCED_LOG_FMT' : 'TRUE',  # Set this to false to debug any error
    'COCOTB_LOG_LEVEL'       : 'INFO'   # Set this to 'DEBUG' to get a verbose logging
}
