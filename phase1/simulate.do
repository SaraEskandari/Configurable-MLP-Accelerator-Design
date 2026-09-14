vlib work
vmap work work


vcom -2002 MATH_PKG.vhd
vcom -2002 TESTPACK.vhd

vcom -2002 BIT_MULTIPLIER.VHD
vcom -2002 ARRAY_MULTIPLIER.vhd
vcom -2002 SIGNED_MULTIPLIER_WRAPPER.vhd
vcom -2002 addition.vhd
vcom -2002 tree-adder.vhd
vcom -2002 MATRIX_MULTIPLIER.vhd
vcom -2002 configuration_multiplexer_matrix.vhd
vcom -2002 matrix_multiplier_tb.vhd

vsim work.MATRIX_MULTIPLIER_TB
add wave -r /*
run -all
