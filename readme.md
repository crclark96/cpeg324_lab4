# lab 3
## collin clark, zach irons

### makefile

running `make` will compile all component object files necessary for
cpu benchmarks outlined in the `benchmarks/` directory (from lab 1) and
run all included cpu benchmarks 

`make all` will compile and run all benchmarks for both the cpu and all
necessary components (good for debugging purposes)

`make <component.o>` will analyze a component for syntactic correctness

`make <component_tb>` will make and run a testbench. any testbench or component
with additional dependencies should be made into an independent rule as the
generic rule only lists the component object and testbench object as
dependencies

additional cpu testbenches can be added by following the `cpu_<name>_tb` format
and will generically compile with all listed cpu dependencies

