
`include "defines.sv"
`timescale 1ns/1ps
module mem(

	input wire                  rst,
	
	//来自执行阶段的信息	
	input wire[`RegAddrBus]     waddr_i,
	input wire                  wreg_i,
	input wire[`RegBus]         wdata_i,
	input wire[`RegBus]         hi_i,
	input wire[`RegBus]         lo_i,
	input wire                  whilo_i,	
	
	//送到回写阶段的信息
	output reg[`RegAddrBus]     waddr_o,
	output reg                  wreg_o,
	output reg[`RegBus]         wdata_o,
	output reg[`RegBus]         hi_o,
	output reg[`RegBus]         lo_o,
	output reg                  whilo_o	
	
);

	
	always_comb begin
		if(rst == `RstEnable) begin
			waddr_o <= `NOPRegAddr;
			wreg_o 	<= `WriteDisable;
			wdata_o <= `ZeroWord;
			hi_o 	<= `ZeroWord;
		  	lo_o 	<= `ZeroWord;
		  	whilo_o <= `WriteDisable;		  
		end else begin
		    waddr_o <= waddr_i;
			wreg_o  <= wreg_i;
			wdata_o <= wdata_i;
			hi_o 	<= hi_i;
			lo_o 	<= lo_i;
			whilo_o <= whilo_i;	
		end    
	end      
			

endmodule