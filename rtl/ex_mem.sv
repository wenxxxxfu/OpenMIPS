`include "defines.sv"
`timescale 1ns/1ps
module ex_mem(

	input   wire    			clk,
	input   wire    			rst,
	
	
	//来自执行阶段的信息	
	input wire[`RegAddrBus]      ex_waddr,
	input wire                   ex_wreg,
	input wire[`RegBus]          ex_wdata, 	
	
	//送到访存阶段的信息
	output reg[`RegAddrBus]      mem_waddr,
	output reg                   mem_wreg,
	output reg[`RegBus]          mem_wdata
	
	
);


	always_ff @ (posedge clk) begin
		if(rst == `RstEnable) begin
			mem_waddr   <= `NOPRegAddr;
			mem_wreg    <= `WriteDisable;
		    mem_wdata   <= `ZeroWord;	
		end else begin
			mem_waddr   <= ex_waddr;
			mem_wreg    <= ex_wreg;
			mem_wdata   <= ex_wdata;			
		end   
	end      
			

endmodule