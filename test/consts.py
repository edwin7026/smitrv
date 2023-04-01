import os


# This file contains important constants for testing

# Absolute path to the src directory
root_path = os.path.abspath(os.path.dirname(__file__) + '/../')

# Important paths
hardware_path = root_path + '/src/hardware/'
model_path = root_path + '/src/models/'

test_root = root_path + '/test/'
test_file_dir = test_root + '/test_bench/'
sim_build = test_root + '/sim_build/'
work_dir = test_root + '/mywork/'

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

    # This 
    'LIBPYTHON_LOC'          : '/snap/gnome-3-38-2004/115/usr/lib/x86_64-linux-gnu/libpython3.8.so',
    
    # These environment variables dictate cocotb logging settings
    'COCOTB_REDUCED_LOG_FMT' : 'FALSE',
    'COCOTB_LOG_LEVEL'       : 'DEBUG'
}

if __name__ == "__main__":
    print(root_path)