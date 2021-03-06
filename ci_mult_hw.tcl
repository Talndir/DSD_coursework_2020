# TCL File Generated by Component Editor 18.1
# Sat Mar 14 04:17:53 GMT 2020
# DO NOT MODIFY


# 
# ci_fp_mult "ci_fp_mult" v1.0
#  2020.03.14.04:17:53
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module ci_fp_mult
# 
set_module_property DESCRIPTION ""
set_module_property NAME ci_fp_mult
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME ci_fp_mult
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL fp_mult
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file fp_mult.v VERILOG PATH ip/fp_mult/fp_mult.v TOP_LEVEL_FILE


# 
# parameters
# 


# 
# display items
# 


# 
# connection point ci_mult_slave
# 
add_interface ci_mult_slave nios_custom_instruction end
set_interface_property ci_mult_slave clockCycle 3
set_interface_property ci_mult_slave operands 2
set_interface_property ci_mult_slave ENABLED true
set_interface_property ci_mult_slave EXPORT_OF ""
set_interface_property ci_mult_slave PORT_NAME_MAP ""
set_interface_property ci_mult_slave CMSIS_SVD_VARIABLES ""
set_interface_property ci_mult_slave SVD_ADDRESS_GROUP ""

add_interface_port ci_mult_slave a dataa Input 32
add_interface_port ci_mult_slave b datab Input 32
add_interface_port ci_mult_slave q result Output 32
add_interface_port ci_mult_slave clk clk Input 1
add_interface_port ci_mult_slave areset reset Input 1

