vlib work
vmap work work

vlog cells.v
vlog netlist_matrix_multiplier.v
vlog Matrix_multiplier_gate_tb.v

vsim -voptargs="+acc" work.matrix_multiplier_gate_tb
add wave -r /*

run -all
