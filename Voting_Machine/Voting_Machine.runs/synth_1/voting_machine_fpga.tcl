# 
# Synthesis run script generated by Vivado
# 

set_msg_config -id {Common 17-41} -limit 10000000
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/GitLocalRepo/Verilog-Design/Voting_Machine/Voting_Machine.cache/wt [current_project]
set_property parent.project_path C:/GitLocalRepo/Verilog-Design/Voting_Machine/Voting_Machine.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo c:/GitLocalRepo/Verilog-Design/Voting_Machine/Voting_Machine.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib {
  C:/GitLocalRepo/Verilog-Design/Voting_Machine/Voting_Machine.srcs/sources_1/imports/new/voting_rule.v
  C:/GitLocalRepo/Verilog-Design/Voting_Machine/Voting_Machine.srcs/sources_1/imports/new/led_mux.v
  C:/GitLocalRepo/Verilog-Design/Voting_Machine/Voting_Machine.srcs/sources_1/imports/new/clk_gen.v
  C:/GitLocalRepo/Verilog-Design/Voting_Machine/Voting_Machine.srcs/sources_1/imports/new/bcd_to_7seg.v
  C:/GitLocalRepo/Verilog-Design/Voting_Machine/Voting_Machine.srcs/sources_1/imports/new/voting_machine_fpga.v
}
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/GitLocalRepo/Verilog-Design/Voting_Machine/Voting_Machine.srcs/constrs_1/new/voting_machine_fpga.xdc
set_property used_in_implementation false [get_files C:/GitLocalRepo/Verilog-Design/Voting_Machine/Voting_Machine.srcs/constrs_1/new/voting_machine_fpga.xdc]


synth_design -top voting_machine_fpga -part xc7a100tcsg324-1


write_checkpoint -force -noxdef voting_machine_fpga.dcp

catch { report_utilization -file voting_machine_fpga_utilization_synth.rpt -pb voting_machine_fpga_utilization_synth.pb }
