# This file can be populated with various utility functions for testing purposes


import utils

# Empty class that stores input signal and delay after setting
class SampleSignals:
    def __init__(self, val, delay = 1):
        self.val = val
        self.delay = delay

# Get a alias-signal dictionary out of signals.yaml
def get_signals(name, sig_type):
    return utils.load_yaml('./../../signals.yaml')[name][sig_type]
    
    