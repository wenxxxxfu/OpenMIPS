
`include "defines.sv"
`timescale 1ns/1ps
module mem_wb(

	input wire      			clk,
	input wire      			rst,
	

	//来自访存阶段的信息	
	input wire[`RegAddrBus]      mem_waddr,
	input wire                   mem_wreg,
	input wire[`RegBus]          mem_wdata,

	//送到回写阶段的信息
	output reg[`RegAddrBus]      wb_waddr,
	output reg                   wb_wreg,
	output reg[`RegBus]          wb_wdata	       
	
);


	always_ff @ (posedge clk) begin
		if(rst == `RstEnable) begin
			wb_waddr <= `NOPRegAddr;
			wb_wreg  <= `WriteDisable;
		    wb_wdata <= `ZeroWord;	
		end else begin
			wb_waddr <= mem_waddr;
			wb_wreg  <= mem_wreg;
			wb_wdata <= mem_wdata;
		end   
	end    
		
endmodule