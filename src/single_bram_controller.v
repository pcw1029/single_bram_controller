`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/27 16:48:45
// Design Name: 
// Module Name: singleBramCtrl
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
`timescale 1 ns / 1 ps

module single_bram_controller #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 10,
    parameter MEM_SIZE = 1024
)(
    input                   clk,
    input                   reset_n,
    input                   i_run,
    input                   i_mode,
    input  [ADDR_WIDTH-1:0] i_bramAddr,
    input  [DATA_WIDTH-1:0] i_write_data,
    output                  o_idle,
    output                  o_write,
    output                  o_read,
    output                  o_done,

// Memory I/F
    output[ADDR_WIDTH-1:0]  bramAddr,
    output                  bramCe,
    output                  bramWe,
    input [DATA_WIDTH-1:0]  bramReadData,
    output[DATA_WIDTH-1:0]  bramWriteData,

// output read value from BRAM
    output                  o_read_valid,
    output[DATA_WIDTH-1:0]  o_read_data
);


/////// Local Param. to define state ////////
localparam S_IDLE       = 3'd0;
localparam S_WRITE      = 3'd1;
localparam S_READ       = 3'd2;
localparam S_DONE       = 3'd3;
localparam S_UNKOWN     = 3'd4;

localparam READ_MODE    = 1'b0;
localparam WRITE_MODE   = 1'b1;

/////// Type ////////
reg [2:0]   current_state; // Current state  (F/F)
reg [2:0]   next_state; // Next state (Variable in Combinational Logic)
wire        is_write_done;
wire        is_read_done;
wire        is_done;

/////// Main ////////

// Step 1. always block to update state 
always @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        current_state <= S_IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Step 2. always block to compute next_state
//always @(current_state or i_run or is_done) 
always @(*)
begin
    next_state = current_state; // To prevent Latch.
    case(current_state)
        S_IDLE :
            if(i_run) begin                
                if(i_mode == 1'b1) begin
                    next_state = S_WRITE;
                end else if(i_mode == 1'b0) begin
                    next_state = S_READ;
                end else begin
                    next_state = S_UNKOWN;
                end   
            end
        S_WRITE : 
            if(is_write_done) begin
                next_state = S_DONE;
            end
        S_READ  : 
            if(is_read_done) begin
                next_state = S_DONE;
            end                    
        S_DONE  :
            if(is_done) begin
                next_state = S_IDLE;
            end
    endcase
end 

// Step 3.  always block to compute output
// Added to communicate with control signals.
assign o_idle       = (current_state == S_IDLE);
assign o_write      = (current_state == S_WRITE);
assign o_read       = (current_state == S_READ);
assign o_done       = (current_state == S_DONE);

reg [1:0] num_cnt; 
assign is_write_done    = o_write && (num_cnt == 2'd0);
assign is_read_done     = o_read  && (num_cnt == 2'd0);
assign is_done          = o_done && (num_cnt == 2'd0);
 
always @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        num_cnt <= 0;  
    end else if (is_write_done || is_read_done || is_done) begin
        num_cnt <= 0;  
    end else if (o_write || o_read || o_done) begin
        num_cnt <= num_cnt + 1;
    end 
end

// Assign Memory I/F
assign bramAddr         = i_bramAddr;
assign bramCe           = o_write || o_read || o_done;
assign bramWe           = o_write;
assign bramWriteData    = i_write_data;  // same value;


// output data from memory 
reg                     r_valid;
reg [ADDR_WIDTH-1:0]    r_mem_data;

// 1 cycle latency to sync mem output
always @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        r_valid <= 0;  
    end else begin
        r_valid <= o_done; // read data
    end 
end

assign o_read_valid = r_valid;
assign o_read_data = bramReadData;  // direct assign, bus Matbi recommends you to add a register for timing.

endmodule