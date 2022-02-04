`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/02/03 17:16:12
// Design Name: 
// Module Name: tb_single_bram_ctrl
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_single_bram_ctrl();

`define ADDR_WIDTH 10
`define DATA_WIDTH 32

integer                 fd;

reg                     clk_0;
reg                     reset_n_0;
reg 					i_run_0;
reg [`ADDR_WIDTH-1:0]   i_bramAddr_0;
reg                     i_mode_0;
reg [`DATA_WIDTH-1:0]   i_write_data_0;
wire                    o_done_0;
wire                    o_idle_0;
wire                    o_read_0;
wire [`DATA_WIDTH-1:0]  o_read_data_0;
wire                    o_read_valid_0;
wire                    o_write_0;

reg 					i_run_1;
reg [`ADDR_WIDTH-1:0]   i_bramAddr_1;
reg                     i_mode_1;
reg [`DATA_WIDTH-1:0]   i_write_data_1;
wire                    o_done_1;
wire                    o_idle_1;
wire                    o_read_1;
wire [`DATA_WIDTH-1:0]  o_read_data_1;
wire                    o_read_valid_1;
wire                    o_write_1;


// clk gen
always
    #5 clk_0 = ~clk_0;

integer i;

initial begin
//initialize value
$display("initialize value [%0d]", $time);
    reset_n_0   = 1;
    clk_0         = 0;
	i_run_0 	= 0;
	i_run_1 	= 0;
	i_mode_0   = 0;
	i_mode_1   = 0;
	
// reset_n gen
$display("Reset! [%0d]", $time);
# 30
    reset_n_0 = 0;
# 10
    reset_n_0 = 1;
# 10
@(posedge clk_0);


$display("Check Idle [%0d]", $time);
wait(o_idle_0);

$display("Start Write! [%d]", $time);
	for(i=0; i<10; i = i+1) begin
		@(negedge clk_0);
		i_run_0 = 1;
		i_bramAddr_0 = i;
        i_mode_0 = 1;
        i_write_data_0 = i;
		@(posedge clk_0);
		i_run_0 = 0;
		wait(o_done_0);
		wait(!o_done_0);
	end
	

$display("Start Read! [%d]", $time);    
	for(i=1; i<10; i = i+1) begin
		@(negedge clk_0);
		i_run_1 = 1;
		i_bramAddr_1 = i;
        i_mode_1 = 0;
        $display("read bram [%d]", o_read_data_1);
		@(posedge clk_0);
		i_run_1 = 0;
		wait(o_read_valid_1);
		wait(!o_read_valid_1);		
	end	
	i_bramAddr_1 = 10;
	

# 100
$display("Success Simulation!! (Matbi = gudok & joayo) [%0d]", $time);
$finish;
end

// Call DUT


design_1_wrapper tb_single_bram_ctrl(
    .clk_0            (clk_0),
    .i_bramAddr_0   (i_bramAddr_0),
    .i_mode_0       (i_mode_0),
    .i_run_0        (i_run_0),
    .i_write_data_0 (i_write_data_0),
    .o_done_0       (o_done_0),
    .o_idle_0       (o_idle_0),
    .o_read_0       (o_read_0),
    .o_read_data_0  (o_read_data_0),
    .o_read_valid_0 (o_read_valid_0),
    .o_write_0      (o_write_0),
    .reset_n_0      (reset_n_0),
    .i_bramAddr_1   (i_bramAddr_1),
    .i_mode_1       (i_mode_1),
    .i_run_1        (i_run_1),
    .i_write_data_1 (i_write_data_1),
    .o_done_1       (o_done_1),
    .o_idle_1       (o_idle_1),
    .o_read_1       (o_read_1),
    .o_read_data_1  (o_read_data_1),
    .o_read_valid_1 (o_read_valid_1),
    .o_write_1      (o_write_1)    
);
    
endmodule
