
`include "defines.sv"
`timescale 1ns/1ps
module mem(

	input wire                  rst,
	
	//来自执行阶段的信息	
	input wire[`RegAddrBus]     waddr_i,
	input wire                  wreg_i,
	input wire[`RegBus]         wdata_i,
	
	//送到回写阶段的信息
	output reg[`RegAddrBus]     waddr_o,
	output reg                  wreg_o,
	output reg[`RegBus]         wdata_o
	
);

	
	always_comb begin
		if(rst == `RstEnable) begin
			waddr_o <= `NOPRegAddr;
			wreg_o <= `WriteDisable;
		    wdata_o <= `ZeroWord;
		end else begin
		    waddr_o <= waddr_i;
			wreg_o  <= wreg_i;
			wdata_o <= wdata_i;
		end    
	end      
			

endmodule