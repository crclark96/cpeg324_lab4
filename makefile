CC = /usr/local/bin/ghdl
DEPS = reg_file.o shift_reg_8_bit.o shift_reg.o dff.o mux_4_1.o cpu.o controller.o demux_1_4.o sign_extend.o instruction_skip.o print_module.o mux_2_1.o adder_8_bit.o full_adder.o

default: cpu_load_tb cpu_sub_tb cpu_add_tb cpu_comp_tb

all: controller_tb cpu_add_tb cpu_comp_tb cpu_load_tb cpu_sub_tb demux_1_4_tb instruction_skip_tb print_module_tb reg_file_tb shift_reg_8_bit_tb shift_reg_tb sign_extend_tb

%.o: %.vhdl
	$(CC) -a $^

%_tb: %_tb.o %.o
	$(CC) -e $@
	$(CC) -r $@ --vcd=$@.vcd

cpu_%_tb: $(DEPS) cpu_%_tb.o
	$(CC) -e $@
	$(CC) -r $@ --vcd=$@.vcd

reg_file_tb: reg_file_tb.o reg_file.o shift_reg_8_bit.o shift_reg.o dff.o mux_4_1.o demux_1_4.o
	$(CC) -e $@
	$(CC) -r $@ --vcd=$@.vcd

shift_reg_tb: shift_reg.o shift_reg_tb.o dff.o mux_4_1.o
	$(CC) -e $@
	$(CC) -r $@ --vcd=$@.vcd

shift_reg_8_bit_tb: shift_reg_8_bit.o shift_reg_8_bit_tb.o shift_reg.o dff.o mux_4_1.o

instruction_skip_tb: instruction_skip_tb.o instruction_skip.o shift_reg.o dff.o mux_4_1.o
	$(CC) -e $@
	$(CC) -r $@ --vcd=$@.vcd

intermediate_reg_tb: intermediate_reg_tb.o intermediate_reg.o dff.o
	$(CC) -e $@
	$(CC) -r $@ --vcd=$@.vcd

clean:
	rm *.o *_tb *.cf *.vcd

