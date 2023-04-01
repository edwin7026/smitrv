# This file contains necessary support functions for the framework

import yaml

'''
This method helps to safely load a yaml file
Arguments:
    file_name: the name of the yaml file with path
Output:
    A pythonic dictionary for the corresponding yaml if all goes well
'''
def load_yaml(file_name):
    with open(file_name, 'r') as stream:
        try:
            return yaml.safe_load(stream)
        except yaml.YAMLError as exc:
            print(exc)