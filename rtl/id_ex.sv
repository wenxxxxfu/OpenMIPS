`include "defines.sv"
`timescale 1ns/1ps
module id_ex(

    input wire                     clk,
    input wire                     rst,

        
	//从译码阶段传递的信息
    input wire[`AluOpBus]         id_aluop,
    input wire[`AluSelBus]        id_alusel,
    input wire[`RegBus]           id_reg1_data,
    input wire[`RegBus]           id_reg2_data,
    input wire[`RegAddrBus]       id_waddr,
    input wire                    id_wreg,	
        
	//传递到执行阶段的信息
    output reg[`AluOpBus]         ex_aluop,
    output reg[`AluSelBus]        ex_alusel,
    output reg[`RegBus]           ex_reg1_data,
    output reg[`RegBus]           ex_reg2_data,
    output reg[`RegAddrBus]       ex_waddr,
    output reg                    ex_wreg
	
);

	always_ff @ (posedge clk) begin
		if (rst == `RstEnable) begin
			ex_aluop         <= `EXE_NOP_OP;
			ex_alusel        <= `EXE_RES_NOP;
			ex_reg1_data     <= `ZeroWord;
			ex_reg2_data     <= `ZeroWord;
			ex_waddr         <= `NOPRegAddr;
			ex_wreg          <= `WriteDisable;
		end else begin		
			ex_aluop         <= id_aluop;
			ex_alusel        <= id_alusel;
			ex_reg1_data     <= id_reg1_data;
			ex_reg2_data     <= id_reg2_data;
			ex_waddr         <= id_waddr;
			ex_wreg          <= id_wreg;		
		end
	end
	
endmodule