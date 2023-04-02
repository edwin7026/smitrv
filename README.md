# smitrv
A verilog implementation of RISC-V core from SMIT.

## Contributing to the source

The source directory is composed of the following directories:

- `src/hardware` strictly contains the verilog files
- `src/models` strictly contains the corresponding reference models. The models may be written in any language but it should be enclosed within a python wrapper for testing purposes. Every top python model file should be suffixed with `_model.py`

Every sufficiently complicated module must have a corresponding model.

## Getting started with the testing framework
The python version used through the testing of the framework is `3.10.0`

- Verilator is the prefered simulator. NOTE: The framework is compatible with Verilator version `4.106` only. Any later or earlier versions are incompatible. Verilator can be installed by following the guidelines [here](https://verilator.org/guide/latest/install.html#detailed-build-instructions).
- The testing framework is based on [Cocotb](https://docs.cocotb.org/en/stable/index.html). The following command will install the required pip packages. In the `test/` directory, run:

        $ pip install -r requirements.txt

- For waveform generation, the framework uses [`gtkwave`](https://gtkwave.sourceforge.net/) to read `.fst` files. To install `gtkwave`, run (Ubuntu):

        $ sudo apt-get install gtkwave


## How to compose and run tests?

Following are the various files of interest for the test engineer
- `test/test_list.yaml` file helps you populate names of modules for testing.
- `test/signals.yaml` is used to furnish the signals of interest in the test hardware module. The signals may be categorized under the nodes `inputs`, `outputs`, `wires` and `reg`.

`test/test_bench/` directory holds the various tests for a target module. Python test files should be prefixed with `test_`. The framework automatically searches for `@cocotb.test` decorated functions in every enabled module and initiates the test.

## How to contribute?
Please read `CONTRIBUTING.md` for notes on how to contribute. Check the issues tab and engage in discussions.
