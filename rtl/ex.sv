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
	logic [`DoubleRegBus] mulres; //保存乘法结果，宽度为 64 位
	logic [`RegBus] HI;
	logic [`RegBus] LO;
	logic [`RegBus] reg2_i_mux;  // 保存输入的第二个操作数 reg2_i 的补码
	logic [`RegBus] reg1_i_not;	 // 保存输入的第一个操作数 reg1_i 取反后的值
	logic [`RegBus] result_sum;  // 保存加法结果
	logic  ov_sum;				 // 保存溢出情况
	logic  reg1_eq_reg2;		 // 第一个操作数是否等于第二个操作数
	logic  reg1_lt_reg2;		 // 第一个操作数是否小于第二个操作数
	logic [`RegBus] opdata1_mult;// 乘法操作中的被乘数
	logic [`RegBus] opdata2_mult;// 乘法操作中的乘数
	logic [`DoubleRegBus] hilo_temp;	// 临时保存乘法结果，宽度为 64 位
	logic [`RegBus] arithmeticres;
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

	assign reg2_i_mux =((aluop_i == `EXE_SUB_OP) || (aluop_i == `EXE_SUBU_OP) ||
						(aluop_i == `EXE_SLT_OP)) ? (~reg2_data_i)+1 : reg2_data_i;
	assign result_sum = reg1_data_i + reg2_i_mux;
	assign ov_sum     = ((!reg1_data_i[31] && !reg2_i_mux[31]) &&  result_sum[31]) ||
						( reg1_data_i[31]  && reg2_i_mux[31]) && (!result_sum[31]);  	
	assign reg1_lt_reg2 = ((aluop_i == `EXE_SLT_OP)) ? ((reg1_data_i[31] && !reg2_data_i[31]) ||
						(!reg1_data_i[31] && !reg2_data_i[31] && result_sum[31])||
						( reg1_data_i[31] && reg2_data_i[31] && result_sum[31]))
						: (reg1_data_i < reg2_data_i);
    assign reg1_i_not = ~reg1_data_i;

    always_comb begin
		if(rst == `RstEnable) begin
			arithmeticres <= `ZeroWord;
		end else begin
			case (aluop_i)
				`EXE_SLT_OP, `EXE_SLTU_OP:arithmeticres <= reg1_lt_reg2 ;
				`EXE_ADD_OP, `EXE_ADDU_OP, `EXE_ADDI_OP, `EXE_ADDIU_OP:	arithmeticres <= result_sum; 
				`EXE_SUB_OP, `EXE_SUBU_OP:arithmeticres <= result_sum; 
				`EXE_CLZ_OP:begin
					arithmeticres <=    reg1_data_i[31] ? 0  : reg1_data_i[30] ? 1  : reg1_data_i[29] ? 2  :
                                        reg1_data_i[28] ? 3  : reg1_data_i[27] ? 4  : reg1_data_i[26] ? 5  :
                                        reg1_data_i[25] ? 6  : reg1_data_i[24] ? 7  : reg1_data_i[23] ? 8  : 
                                        reg1_data_i[22] ? 9  : reg1_data_i[21] ? 10 : reg1_data_i[20] ? 11 :
                                        reg1_data_i[19] ? 12 : reg1_data_i[18] ? 13 : reg1_data_i[17] ? 14 : 
                                        reg1_data_i[16] ? 15 : reg1_data_i[15] ? 16 : reg1_data_i[14] ? 17 : 
                                        reg1_data_i[13] ? 18 : reg1_data_i[12] ? 19 : reg1_data_i[11] ? 20 :
                                        reg1_data_i[10] ? 21 : reg1_data_i[9]  ? 22 : reg1_data_i[8]  ? 23 : 
                                        reg1_data_i[7]  ? 24 : reg1_data_i[6]  ? 25 : reg1_data_i[5]  ? 26 : 
                                        reg1_data_i[4]  ? 27 : reg1_data_i[3]  ? 28 : reg1_data_i[2]  ? 29 : 
                                        reg1_data_i[1]  ? 30 : reg1_data_i[0]  ? 31 : 32 ;
				end
				`EXE_CLO_OP:begin
					arithmeticres <=   (reg1_i_not[31] ? 0 : reg1_i_not[30]  ? 1 : reg1_i_not[29]  ? 2 :
                                        reg1_i_not[28] ? 3 : reg1_i_not[27]  ? 4 : reg1_i_not[26]  ? 5 :
                                        reg1_i_not[25] ? 6 : reg1_i_not[24]  ? 7 : reg1_i_not[23]  ? 8 : 
                                        reg1_i_not[22] ? 9 : reg1_i_not[21]  ? 10 : reg1_i_not[20] ? 11 :
                                        reg1_i_not[19] ? 12 : reg1_i_not[18] ? 13 : reg1_i_not[17] ? 14 : 
                                        reg1_i_not[16] ? 15 : reg1_i_not[15] ? 16 : reg1_i_not[14] ? 17 : 
                                        reg1_i_not[13] ? 18 : reg1_i_not[12] ? 19 : reg1_i_not[11] ? 20 :
                                        reg1_i_not[10] ? 21 : reg1_i_not[9]  ? 22 : reg1_i_not[8]  ? 23 : 
                                        reg1_i_not[7]  ? 24 : reg1_i_not[6]  ? 25 : reg1_i_not[5]  ? 26 : 
                                        reg1_i_not[4]  ? 27 : reg1_i_not[3]  ? 28 : reg1_i_not[2]  ? 29 : 
                                        reg1_i_not[1]  ? 30 : reg1_i_not[0]  ? 31 : 32) ;
				end
				default:				begin
					arithmeticres <= `ZeroWord;
				end
			endcase
		end
	end

//取得乘法操作的操作数，如果是有符号除法且操作数是负数，那么取反加一
	assign opdata1_mult = (((aluop_i == `EXE_MUL_OP) || (aluop_i == `EXE_MULT_OP))
													&& (reg1_data_i[31] == 1'b1)) ? (~reg1_data_i + 1) : reg1_data_i;

    assign opdata2_mult = (((aluop_i == `EXE_MUL_OP) || (aluop_i == `EXE_MULT_OP))
													&& (reg2_data_i[31] == 1'b1)) ? (~reg2_data_i + 1) : reg2_data_i;		

    assign hilo_temp = opdata1_mult * opdata2_mult;																				

	always_comb begin
		if(rst == `RstEnable) begin
			mulres <= {`ZeroWord,`ZeroWord};
		end else if ((aluop_i == `EXE_MULT_OP) || (aluop_i == `EXE_MUL_OP))begin
			if(reg1_data_i[31] ^ reg2_data_i[31] == 1'b1) begin
				mulres <= ~hilo_temp + 1;
			end else begin
                mulres <= hilo_temp;
			end
		end else begin
				mulres <= hilo_temp;
		end
	end

	always_comb begin
		waddr_o <= waddr_i;	 	 	
		if(((aluop_i == `EXE_ADD_OP) || (aluop_i == `EXE_ADDI_OP) ||
        (aluop_i == `EXE_SUB_OP)) && (ov_sum == 1'b1)) begin
            wreg_o <= `WriteDisable;
        end else begin
            wreg_o <= wreg_i;
            end
		case(alusel_i)
			`EXE_RES_LOGIC:wdata_o <= logicout;
			`EXE_RES_SHIFT:wdata_o <= shiftres;
			`EXE_RES_MOVE: wdata_o <= moveres;
            `EXE_RES_ARITHMETIC:wdata_o <= arithmeticres;
            `EXE_RES_MUL:  wdata_o <= mulres[31:0];
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
        end else if((aluop_i == `EXE_MULT_OP) || (aluop_i == `EXE_MULTU_OP)) begin
			whilo_o <= `WriteEnable;
			hi_o    <= mulres[63:32];
			lo_o    <= mulres[31:0];		
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