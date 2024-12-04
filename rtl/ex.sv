`include "defines.sv"
`timescale 1ns/1ps
module ex(

	input wire                    rst,
	
	//送到执行阶段的信息
	input wire[`AluOpBus]         aluop_i,
	input wire[`AluSelBus]        alusel_i,
	input wire[`RegBus]           reg1_data_i,
	input wire[`RegBus]           reg2_data_i,
	input wire[`RegAddrBus]       waddr_i,
	input wire                    wreg_i,

	//HI、LO寄存器的值
	input wire[`RegBus]           hi_i,
	input wire[`RegBus]           lo_i,

	//回写阶段的指令是否要写HI、LO，用于检测HI、LO的数据相关
	input wire[`RegBus]           wb_hi_i,
	input wire[`RegBus]           wb_lo_i,
	input wire                    wb_whilo_i,
	
	//访存阶段的指令是否要写HI、LO，用于检测HI、LO的数据相关
	input wire[`RegBus]           mem_hi_i,
	input wire[`RegBus]           mem_lo_i,
	input wire                    mem_whilo_i,

	
	output reg[`RegAddrBus]       waddr_o,
	output reg                    wreg_o,
	output reg[`RegBus]           wdata_o,

	output reg[`RegBus]           hi_o,
	output reg[`RegBus]           lo_o,
	output reg                    whilo_o	
	
);

	logic [`RegBus] logicout;
	logic [`RegBus] shiftres;
	logic [`RegBus] moveres;
	logic [`RegBus] HI;
	logic [`RegBus] LO;
		

	always_comb begin
		if(rst == `RstEnable) begin
			logicout <= `ZeroWord;
		end else begin
			case (aluop_i)
				`EXE_OR_OP: logicout <= reg1_data_i | reg2_data_i;
				`EXE_AND_OP:logicout <= reg1_data_i & reg2_data_i;
				`EXE_NOR_OP:logicout <= ~(reg1_data_i |reg2_data_i);
				`EXE_XOR_OP:logicout <= reg1_data_i ^ reg2_data_i;
				default:    logicout <= `ZeroWord;
			endcase
		end    
	end      


	always_comb begin
		if(rst == `RstEnable) begin
			shiftres <= `ZeroWord;
		end else begin
			case (aluop_i)
				`EXE_SLL_OP:shiftres <= reg2_data_i << reg1_data_i[4:0];
				`EXE_SRL_OP:shiftres <= reg2_data_i >> reg1_data_i[4:0];
				`EXE_SRA_OP:shiftres <= ({32{reg2_data_i[31]}} << (6'd32-{1'b0, reg1_data_i[4:0]}))| reg2_data_i >> reg1_data_i[4:0];
				default:	shiftres <= `ZeroWord;
			endcase
		end    
	end     


	always_comb begin
		waddr_o <= waddr_i;	 	 	
		wreg_o <= wreg_i;
		case(alusel_i)
			`EXE_RES_LOGIC:wdata_o <= logicout;
			`EXE_RES_SHIFT:wdata_o <= shiftres;
			`EXE_RES_MOVE: wdata_o <= moveres;
			default:	   wdata_o <=`ZeroWord;
		endcase
	end	

	always_comb begin
		if(rst == `RstEnable) begin
			{HI,LO} <= {`ZeroWord,`ZeroWord};
		end else if(mem_whilo_i == `WriteEnable) begin
			{HI,LO} <= {mem_hi_i,mem_lo_i};
		end else if(wb_whilo_i == `WriteEnable) begin
			{HI,LO} <= {wb_hi_i,wb_lo_i};
		end else begin
			{HI,LO} <= {hi_i,lo_i};			
		end
		end	
	
	always_comb begin
		if(rst == `RstEnable) begin
	  		moveres <= `ZeroWord;
	 	end else begin
	   		moveres <= `ZeroWord;
			case (aluop_i)
				`EXE_MFHI_OP:moveres <= HI;
				`EXE_MFLO_OP:moveres <= LO;
				`EXE_MOVZ_OP:moveres <= reg1_data_i;
				`EXE_MOVN_OP:moveres <= reg1_data_i;
				default : begin
				end
			endcase
	  end
	end	 

	always_comb begin
		if(rst == `RstEnable) begin
			whilo_o <= `WriteDisable;
			hi_o 	<= `ZeroWord;
			lo_o 	<= `ZeroWord;		
		end else if(aluop_i == `EXE_MTHI_OP) begin
			whilo_o <= `WriteEnable;
			hi_o 	<= reg1_data_i;
			lo_o 	<= LO;
		end else if(aluop_i == `EXE_MTLO_OP) begin
			whilo_o <= `WriteEnable;
			hi_o 	<= HI;
			lo_o 	<= reg1_data_i;
		end else begin
			whilo_o <= `WriteDisable;
			hi_o 	<= `ZeroWord;
			lo_o 	<= `ZeroWord;
		end				
	end			
	endmodule