create_project single_bram_controller /home/pcw1029/projects/MTTS/hw/single_bram_controller -part xczu3eg-sfvc784-1-e
add_files -norecurse {/home/pcw1029/projects/MTTS/hw/single_bram_controller/src/single_bram_controller.v}
update_compile_order -fileset sources_1


ipx::package_project -root_dir /home/pcw1029/projects/MTTS/hw/single_bram_controller -vendor user.org -library user -taxonomy /UserIP

ipx::merge_project_changes files [ipx::current_core]

set_property core_revision 2 [ipx::current_core]
ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::save_core [ipx::current_core]
set_property  ip_repo_paths  /home/pcw1029/projects/MTTS/hw/single_bram_controller [current_project]
update_ip_catalog

close_project

create_project single_bram_controller /home/pcw1029/projects/MTTS/hw/test_single_bram_controller -part xczu3eg-sfvc784-1-e

create_bd_design "design_1"
update_compile_order -fileset sources_1

startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_0
endgroup

set_property -dict [list CONFIG.Memory_Type {True_Dual_Port_RAM} CONFIG.Enable_32bit_Address {false} CONFIG.Use_Byte_Write_Enable {false} CONFIG.Byte_Size {9} CONFIG.Write_Depth_A {1024} CONFIG.Enable_B {Use_ENB_Pin} CONFIG.Register_PortA_Output_of_Memory_Primitives {true} CONFIG.Register_PortB_Output_of_Memory_Primitives {true} CONFIG.Use_RSTA_Pin {false} CONFIG.Port_B_Clock {100} CONFIG.Port_B_Write_Rate {50} CONFIG.Port_B_Enable_Rate {100} CONFIG.use_bram_block {Stand_Alone} CONFIG.EN_SAFETY_CKT {false}] [get_bd_cells blk_mem_gen_0]



set_property  ip_repo_paths  /home/pcw1029/projects/MTTS/hw/single_bram_controller [current_project]
update_ip_catalog

create_bd_cell -type ip -vlnv user.org:user:single_bram_controller:1.0 single_bram_controll_0

startgroup
make_bd_pins_external  [get_bd_pins single_bram_controll_0/clk]
endgroup
connect_bd_net [get_bd_ports clk_0] [get_bd_pins blk_mem_gen_0/clka]

connect_bd_net [get_bd_pins single_bram_controll_0/bramReadData] [get_bd_pins blk_mem_gen_0/douta]
connect_bd_net [get_bd_pins single_bram_controll_0/bramWriteData] [get_bd_pins blk_mem_gen_0/dina]
connect_bd_net [get_bd_pins single_bram_controll_0/bramWe] [get_bd_pins blk_mem_gen_0/wea]
connect_bd_net [get_bd_pins single_bram_controll_0/bramCe] [get_bd_pins blk_mem_gen_0/ena]
connect_bd_net [get_bd_pins single_bram_controll_0/bramAddr] [get_bd_pins blk_mem_gen_0/addra]

startgroup
make_bd_pins_external  [get_bd_cells single_bram_controll_0]
make_bd_intf_pins_external  [get_bd_cells single_bram_controll_0]
endgroup


create_bd_cell -type ip -vlnv user.org:user:single_bram_controller:1.0 single_bram_controll_1
connect_bd_net [get_bd_ports clk_0] [get_bd_pins single_bram_controll_1/clk]
connect_bd_net [get_bd_ports reset_n_0] [get_bd_pins single_bram_controll_1/reset_n]
connect_bd_net [get_bd_pins single_bram_controll_1/bramReadData] [get_bd_pins blk_mem_gen_0/doutb]
connect_bd_net [get_bd_pins single_bram_controll_1/bramCe] [get_bd_pins blk_mem_gen_0/enb]
connect_bd_net [get_bd_pins single_bram_controll_1/bramWe] [get_bd_pins blk_mem_gen_0/web]
connect_bd_net [get_bd_pins single_bram_controll_1/bramWriteData] [get_bd_pins blk_mem_gen_0/dinb]
connect_bd_net [get_bd_ports clk_0] [get_bd_pins blk_mem_gen_0/clkb]
connect_bd_net [get_bd_pins single_bram_controll_1/bramAddr] [get_bd_pins blk_mem_gen_0/addrb]

startgroup
make_bd_pins_external  [get_bd_cells single_bram_controll_1]
make_bd_intf_pins_external  [get_bd_cells single_bram_controll_1]
endgroup

regenerate_bd_layout
save_bd_design

make_wrapper -files [get_files /home/pcw1029/projects/MTTS/hw/test_single_bram_controller/single_bram_controller.srcs/sources_1/bd/design_1/design_1.bd] -top
add_files -norecurse /home/pcw1029/projects/MTTS/hw/test_single_bram_controller/single_bram_controller.srcs/sources_1/bd/design_1/hdl/design_1_wrapper.v


set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse /home/pcw1029/projects/MTTS/hw/single_bram_controller/src/tb_single_bram_ctrl.v
update_compile_order -fileset sim_1
