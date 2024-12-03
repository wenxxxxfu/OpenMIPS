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

	
	output reg[`RegAddrBus]       waddr_o,
	output reg                    wreg_o,
	output reg[`RegBus]           wdata_o
	
);

	logic [`RegBus] logicout;
	logic [`RegBus] shiftres;

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
				default:shiftres <= `ZeroWord;
			endcase
		end    
	end     


 always_comb begin
	waddr_o <= waddr_i;	 	 	
  	wreg_o <= wreg_i;
    case(alusel_i)
        `EXE_RES_LOGIC:begin
            wdata_o <= logicout;
        end
        `EXE_RES_SHIFT:begin
            wdata_o <= shiftres;
        end
        default:begin
            wdata_o<=`ZeroWord;
        end
    endcase
end	

endmodule