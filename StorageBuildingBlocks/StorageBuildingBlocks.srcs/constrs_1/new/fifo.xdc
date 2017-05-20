 ########################################################
# Design Constraint File #
# FILE NAME: voting_machine_fpga.xdc #
# DATE: 7/25/14 #
########################################################

set_property -dict { PACKAGE_PIN E3 IOSTANDARD LVCMOS33 } [get_ports { clk100MHz }];
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports {clk100MHz}];

set_property -dict { PACKAGE_PIN U11 IOSTANDARD LVCMOS33 } [get_ports { wr }];
set_property -dict { PACKAGE_PIN V10 IOSTANDARD LVCMOS33 } [get_ports { enable }];

set_property -dict { PACKAGE_PIN V12 IOSTANDARD LVCMOS33 } [get_ports { wnrLED }];
set_property -dict { PACKAGE_PIN V11 IOSTANDARD LVCMOS33 } [get_ports { enLED }];

set_property -dict { PACKAGE_PIN R16 IOSTANDARD LVCMOS33 } [get_ports { in[0] }];
set_property -dict { PACKAGE_PIN T13 IOSTANDARD LVCMOS33 } [get_ports { in[1] }];
set_property -dict { PACKAGE_PIN H6  IOSTANDARD LVCMOS33 } [get_ports { in[2] }];
set_property -dict { PACKAGE_PIN U12 IOSTANDARD LVCMOS33 } [get_ports { in[3] }];

set_property -dict { PACKAGE_PIN U14 IOSTANDARD LVCMOS33 } [get_ports { inLED[0] }];
set_property -dict { PACKAGE_PIN T16 IOSTANDARD LVCMOS33 } [get_ports { inLED[1] }];
set_property -dict { PACKAGE_PIN V15 IOSTANDARD LVCMOS33 } [get_ports { inLED[2] }];
set_property -dict { PACKAGE_PIN V14 IOSTANDARD LVCMOS33 } [get_ports { inLED[3] }];

set_property -dict { PACKAGE_PIN H17 IOSTANDARD LVCMOS33 } [get_ports { out[0] }];
set_property -dict { PACKAGE_PIN K15 IOSTANDARD LVCMOS33 } [get_ports { out[1] }];
set_property -dict { PACKAGE_PIN J13 IOSTANDARD LVCMOS33 } [get_ports { out[2] }];
set_property -dict { PACKAGE_PIN N14 IOSTANDARD LVCMOS33 } [get_ports { out[3] }];

set_property -dict { PACKAGE_PIN V16 IOSTANDARD LVCMOS33 } [get_ports { full }];
set_property -dict { PACKAGE_PIN U16 IOSTANDARD LVCMOS33 } [get_ports { empty }];

set_property -dict { PACKAGE_PIN M18 IOSTANDARD LVCMOS33 } [get_ports { rst }];
set_property -dict { PACKAGE_PIN P18 IOSTANDARD LVCMOS33 } [get_ports { setCLK }]; 