vlib work
vmap work work

vlog cells.v
vlog netlist_mlp.v
vlog mlp_tb.v

vsim -voptargs="+acc" work.mlp_tb
add wave -r /*

run -all