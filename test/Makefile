# If the first argument is "run"...
ifeq (show_waveform,$(firstword $(MAKECMDGOALS)))
  # use the rest as arguments for "run"
  MODULE := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(MODULE):;@:)
endif

# This command compiles and runs the cocotb based test
.PHONY: cocotb_run
cocotb_run:
	python -c 'import test_facility; test_facility.test_runner()'

# This command invokes gtkwave and passes the dump.fst file to generate the
# waveforms
.PHONY: show_waveform
show_waveform:
	gtkwave sim_build/${MODULE}/dump.fst

# This command simply removes the sim_build folder
.PHONY: clean
clean:
	rm -rf ./sim_build
