# This command compiles and runs the cocotb based test
.PHONY: cocotb_run
cocotb_run:
	python -c 'import test_facility; print(test_facility.test_runner())'

# This command invokes gtkwave and passes the dump.fst file to generate the
# waveforms
.PHONY: show_waveform
show_waveform:
	gtkwave sim_build/dump.fst

# This command simply removes the sim_build folder
.PHONY: clean
clean:
	rm -rf ./sim_build
