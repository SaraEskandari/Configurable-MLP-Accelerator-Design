vlib work
vmap work work

vcom -2002 MATH_PKG.VHD
-- Disable optimization (-O0) for large constant arrays to speed up compilation
vcom -2002 weights_pkg.vhd

vcom -2002 BIT_MULTIPLIER.VHD
vcom -2002 ARRAY_MULTIPLIER.vhd
vcom -2002 SIGNED_MULTIPLIER_WRAPPER.vhd
vcom -2002 addition.vhd
vcom -2002 tree-adder.vhd

vcom -2002 MATRIX_MULTIPLIER.vhd
vcom -2002 relu.vhd
vcom -2002 ARITHMETIC_RIGHT_SHIFTER.vhd
vcom -2002 COMPARATOR.vhd
vcom -2002 SOFTMAX.VHD

vcom -2002 FULLY_CONNECTED_LAYER.vhd

vcom -2002 MLP.VHD
vcom -2002 CONFIGURATION_MLP.VHD

vcom -2002 MLP_TB.VHD

vsim -t 1ns work.MLP_TB

add wave -r /*
run -all
