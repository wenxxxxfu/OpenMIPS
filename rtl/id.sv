`include "defines.sv"
`timescale 1ns/1ps
module id(
    input  logic                   rst,
    input  logic   [`InstAddrBus]  id_pc_i,
    input  logic   [`InstBus    ]  id_inst_i,

    //from exe
    input  logic                   ex_wreg_i,
    input  logic   [`RegBus     ]  ex_wdata_i,
    input  logic   [`RegAddrBus ]  ex_waddr_i,

    //from mem
    input  logic                   mem_wreg_i,
    input  logic   [`RegBus     ]  mem_wdata_i,
    input  logic   [`RegAddrBus ]  mem_waddr_i,

    //regfile
    input  logic   [`RegBus     ]  reg1_data_i,
    input  logic   [`RegBus     ]  reg2_data_i,
    output logic                   reg1_ren_o,
    output logic                   reg2_ren_o,
    output logic   [`RegAddrBus ]  reg1_addr_o,
    output logic   [`RegAddrBus ]  reg2_addr_o,

    //exe
    output logic   [`AluOpBus   ]  aluop_o,
    output logic   [`AluSelBus  ]  alusel_o,
    output logic   [`RegBus     ]  reg1_data_o,
    output logic   [`RegBus     ]  reg2_data_o,
    output logic   [`RegAddrBus ]  w_addr_o,
    output logic                   wreg_o //whether
);
logic inst_vld;
logic[5:0] op;
logic[4:0] op2;
logic[5:0] op3;
logic[4:0] op4;
logic[`RegBus] imm;

assign op   = id_inst_i[31:26];
assign op2  = id_inst_i[10:6];
assign op3  = id_inst_i[5:0];
assign op4  = id_inst_i[20:16];

always_comb begin
    if(rst == `RstEnable) begin
        aluop_o     <=  `EXE_NOP_OP;
        alusel_o    <=  `EXE_RES_NOP;
        w_addr_o    <=  `NOPRegAddr;
        wreg_o      <=  `WriteDisable;
        inst_vld    <=  `InstInvalid;
        reg1_ren_o  <=  1'b0;
        reg2_ren_o  <=  1'b0;
        reg1_addr_o <=  `NOPRegAddr;
        reg2_addr_o <=  `NOPRegAddr;
        imm         <=  32'h0;
    end else begin
        aluop_o     <=  `EXE_NOP_OP;
        alusel_o    <=  `EXE_RES_NOP;
        w_addr_o    <=  id_inst_i[15:11];
        wreg_o      <=  `WriteDisable;
        inst_vld    <=  `InstInvalid;
        reg1_ren_o  <=  1'b0;
        reg2_ren_o  <=  1'b0;
        reg1_addr_o <=  id_inst_i[25:21];  
        reg2_addr_o <=  id_inst_i[20:16]; 
        imm         <=  `ZeroWord;    

        case(op)
        `EXE_SPECIAL_INST:	begin
                case (op2)
                    5'b00000:begin
                        case (op3)
                            `EXE_OR:begin
                                wreg_o      <= `WriteEnable;
                                aluop_o     <= `EXE_OR_OP;
                                alusel_o    <= `EXE_RES_LOGIC;
                                reg1_ren_o  <= 1'b1;
                                reg2_ren_o  <= 1'b1;
                                inst_vld    <= `InstValid;	
                                end
                            `EXE_AND:begin
                                wreg_o      <= `WriteEnable;
                                aluop_o     <= `EXE_AND_OP;
                                alusel_o    <= `EXE_RES_LOGIC;
                                reg1_ren_o  <= 1'b1;
                                reg2_ren_o  <= 1'b1;
                                inst_vld    <= `InstValid;
                                end 
                            `EXE_XOR:	begin
                                wreg_o      <= `WriteEnable;
                                aluop_o     <= `EXE_XOR_OP;
                                alusel_o    <= `EXE_RES_LOGIC;
                                reg1_ren_o  <= 1'b1;
                                reg2_ren_o  <= 1'b1;
                                inst_vld    <= `InstValid;
                                end
                            `EXE_NOR:begin
                                wreg_o      <= `WriteEnable;
                                aluop_o     <= `EXE_NOR_OP;
                                alusel_o    <= `EXE_RES_LOGIC;
                                reg1_ren_o  <= 1'b1;
                                reg2_ren_o  <= 1'b1;
                                inst_vld    <= `InstValid;
                                end 
                            `EXE_SLLV: begin
                                wreg_o      <= `WriteEnable;
                                aluop_o     <= `EXE_SLL_OP;
                                alusel_o    <= `EXE_RES_SHIFT;
                                reg1_ren_o  <= 1'b1;
                                reg2_ren_o  <= 1'b1;
                                inst_vld    <= `InstValid;
                                end
                            `EXE_SRLV: begin
                                wreg_o      <= `WriteEnable;
                                aluop_o     <= `EXE_SRL_OP;
                                alusel_o    <= `EXE_RES_SHIFT;
                                reg1_ren_o  <= 1'b1;
                                reg2_ren_o  <= 1'b1;
                                inst_vld    <= `InstValid;
                                end
                            `EXE_SRAV: begin
                                wreg_o      <= `WriteEnable;
                                aluop_o     <= `EXE_SRA_OP;
                                alusel_o    <= `EXE_RES_SHIFT;
                                reg1_ren_o  <= 1'b1;
                                reg2_ren_o  <= 1'b1;
                                inst_vld    <= `InstValid;
                                end	
                            `EXE_SYNC: begin
                                wreg_o      <= `WriteDisable;
                                aluop_o     <= `EXE_NOP_OP;
                                alusel_o    <= `EXE_RES_NOP;
                                reg1_ren_o  <= 1'b0;
                                reg2_ren_o  <= 1'b1;
                                inst_vld    <= `InstValid;
                                end	
                            `EXE_MFHI: begin
                                wreg_o      <= `WriteEnable;
                                aluop_o     <= `EXE_MFHI_OP;
                                alusel_o    <= `EXE_RES_MOVE;
                                reg1_ren_o  <= 1'b0;
                                reg2_ren_o  <= 1'b0;
                                inst_vld    <= `InstValid;
                                end	
                            `EXE_MFLO: begin
                                wreg_o      <= `WriteEnable;	
                                aluop_o     <= `EXE_MFLO_OP;
                                alusel_o    <= `EXE_RES_MOVE;
                                reg1_ren_o  <= 1'b0;
                                reg2_ren_o  <= 1'b0;
                                inst_vld    <= `InstValid;
                                end
                            `EXE_MTHI: begin
                                wreg_o      <= `WriteDisable;
                                aluop_o     <= `EXE_MTHI_OP;
                                reg1_ren_o  <= 1'b1;
                                reg2_ren_o  <= 1'b0;
                                inst_vld    <= `InstValid;
                                end
                            `EXE_MTLO: begin
                                wreg_o      <= `WriteDisable;
                                aluop_o     <= `EXE_MTLO_OP;
                                reg1_ren_o  <= 1'b1;
                                reg2_ren_o  <= 1'b0;
                                inst_vld    <= `InstValid;
                                end
                            `EXE_MOVN: begin
                                aluop_o     <= `EXE_MOVN_OP;
                                alusel_o    <= `EXE_RES_MOVE;
                                reg1_ren_o  <= 1'b1;
                                reg2_ren_o  <= 1'b1;
                                inst_vld    <= `InstValid;
                                if(reg2_data_o != `ZeroWord) begin
                                    wreg_o  <= `WriteEnable;
                                end else begin
                                    wreg_o  <= `WriteDisable;
                                end
                                end
                            `EXE_MOVZ: begin
                                aluop_o     <= `EXE_MOVZ_OP;
                                alusel_o    <= `EXE_RES_MOVE;
                                reg1_ren_o  <= 1'b1;
                                reg2_ren_o  <= 1'b1;
                                inst_vld    <= `InstValid;
                                if(reg2_data_o == `ZeroWord) begin
                                    wreg_o  <= `WriteEnable;
                                end else begin
                                    wreg_o  <= `WriteDisable;
                                end
                                end
                            `EXE_SLT: begin
                                wreg_o      <= `WriteEnable;
                                aluop_o     <= `EXE_SLT_OP;
                                alusel_o    <= `EXE_RES_ARITHMETIC;
                                reg1_ren_o  <= 1'b1;
                                reg2_ren_o  <= 1'b1;
                                inst_vld    <= `InstValid;
                                end
                            `EXE_SLTU: begin
                                wreg_o      <= `WriteEnable;
                                aluop_o     <= `EXE_SLTU_OP;
                                alusel_o    <= `EXE_RES_ARITHMETIC;
                                reg1_ren_o  <= 1'b1;
                                reg2_ren_o  <= 1'b1;
                                inst_vld    <= `InstValid;
                                end
                            `EXE_ADD: begin
                                wreg_o      <= `WriteEnable;
                                aluop_o     <= `EXE_ADD_OP;
                                alusel_o    <= `EXE_RES_ARITHMETIC;
                                reg1_ren_o  <= 1'b1;
                                reg2_ren_o  <= 1'b1;
                                inst_vld    <= `InstValid;
                                end
                            `EXE_ADDU: begin
                                wreg_o      <= `WriteEnable;
                                aluop_o     <= `EXE_ADDU_OP;
                                alusel_o    <= `EXE_RES_ARITHMETIC;
                                reg1_ren_o  <= 1'b1;
                                reg2_ren_o  <= 1'b1;
                                inst_vld    <= `InstValid;
                                end
                            `EXE_SUB: begin
                                wreg_o      <= `WriteEnable;
                                aluop_o     <= `EXE_SUB_OP;
                                alusel_o    <= `EXE_RES_ARITHMETIC;
                                reg1_ren_o  <= 1'b1;
                                reg2_ren_o  <= 1'b1;
                                inst_vld    <= `InstValid;
                                end
                            `EXE_SUBU: begin
                                wreg_o      <= `WriteEnable;	
                                aluop_o     <= `EXE_SUBU_OP;
                                alusel_o    <= `EXE_RES_ARITHMETIC;
                                reg1_ren_o  <= 1'b1;
                                reg2_ren_o  <= 1'b1;
                                inst_vld    <= `InstValid;
                                end
                            `EXE_MULT: begin
                                wreg_o      <= `WriteDisable;
                                aluop_o     <= `EXE_MULT_OP;
                                reg1_ren_o  <= 1'b1;
                                reg2_ren_o  <= 1'b1;
                                inst_vld    <= `InstValid;
                                end
                            `EXE_MULTU: begin
                                wreg_o      <= `WriteDisable;
                                aluop_o     <= `EXE_MULTU_OP;
                                reg1_ren_o  <= 1'b1;
                                reg2_ren_o  <= 1'b1;
                                inst_vld    <= `InstValid;	
                                end     
                            default:begin
                        
                        end
                            endcase
                        end
                        default: begin
                        end
                    endcase	
                    end	
            `EXE_ORI:begin   
                wreg_o      <=  `WriteEnable;
                aluop_o     <=  `EXE_OR_OP;  
                alusel_o    <=  `EXE_RES_LOGIC;
                reg1_ren_o  <=  1'b1;
                reg2_ren_o  <=  1'b0;
                imm         <=  {16'h0,id_inst_i[15:0]};
                w_addr_o    <=  id_inst_i[20:16];
                inst_vld    <=  `InstValid;
                end
            `EXE_ANDI:begin
                wreg_o      <= `WriteEnable;
                aluop_o     <= `EXE_AND_OP;
                alusel_o    <= `EXE_RES_LOGIC;
                reg1_ren_o  <= 1'b1;
                reg2_ren_o  <= 1'b0;
                imm         <= {16'h0, id_inst_i[15:0]};
                w_addr_o    <= id_inst_i[20:16];
                inst_vld    <= `InstValid;	
                end	 	
            `EXE_XORI:begin
                wreg_o      <= `WriteEnable;
                aluop_o     <= `EXE_XOR_OP;
                alusel_o    <= `EXE_RES_LOGIC;
                reg1_ren_o  <= 1'b1;
                reg2_ren_o  <= 1'b0;
                imm         <= {16'h0, id_inst_i[15:0]};
                w_addr_o    <= id_inst_i[20:16];
                inst_vld    <= `InstValid;	
                end	    
            `EXE_LUI:begin
                wreg_o      <= `WriteEnable;
                aluop_o     <= `EXE_OR_OP;
                alusel_o    <= `EXE_RES_LOGIC;
                reg1_ren_o  <= 1'b1;
                reg2_ren_o  <= 1'b0;
                imm <= {id_inst_i[15:0], 16'h0};
                w_addr_o    <= id_inst_i[20:16];
                inst_vld    <= `InstValid;	
                end	 	
            `EXE_PREF:begin
                wreg_o      <= `WriteDisable;
                aluop_o     <= `EXE_NOP_OP;
                alusel_o    <= `EXE_RES_NOP;
                reg1_ren_o  <= 1'b0;
                reg2_ren_o  <= 1'b0;
                inst_vld    <= `InstValid;	
                end
            `EXE_SLTI:begin
                wreg_o      <= `WriteEnable;
                aluop_o     <= `EXE_SLT_OP;
                alusel_o    <= `EXE_RES_ARITHMETIC;
                reg1_ren_o  <= 1'b1;
                reg2_ren_o  <= 1'b0;
                imm <= {{16{id_inst_i[15]}}, id_inst_i[15:0]};
                w_addr_o    <= id_inst_i[20:16];
                inst_vld    <= `InstValid;
                end
            `EXE_SLTIU:begin
                wreg_o      <= `WriteEnable; 
                aluop_o     <= `EXE_SLTU_OP;
                alusel_o    <= `EXE_RES_ARITHMETIC; 
                reg1_ren_o  <= 1'b1;	
                reg2_ren_o  <= 1'b0;
                imm <= {{16{id_inst_i[15]}}, id_inst_i[15:0]};
                w_addr_o    <= id_inst_i[20:16];
                inst_vld    <= `InstValid;
                end
            `EXE_ADDI:begin
                wreg_o      <= `WriteEnable; 
                aluop_o     <= `EXE_ADDI_OP;
                alusel_o    <= `EXE_RES_ARITHMETIC; 
                reg1_ren_o  <= 1'b1;
                reg2_ren_o  <= 1'b0;	  	
                imm <= {{16{id_inst_i[15]}}, id_inst_i[15:0]};
                w_addr_o    <= id_inst_i[20:16]; 
                inst_vld    <= `InstValid;
                end
            `EXE_ADDIU:begin
                wreg_o      <= `WriteEnable; 
                aluop_o     <= `EXE_ADDIU_OP;
                alusel_o    <= `EXE_RES_ARITHMETIC; 
                reg1_ren_o  <= 1'b1;
                reg2_ren_o  <= 1'b0;
                imm <= {{16{id_inst_i[15]}}, id_inst_i[15:0]};
                w_addr_o    <= id_inst_i[20:16];
                inst_vld    <= `InstValid;
                end
            `EXE_SPECIAL2_INST: begin
                case ( op3 )
                    `EXE_CLZ:begin
                        wreg_o      <= `WriteEnable; 
                        aluop_o     <= `EXE_CLZ_OP;
                        alusel_o    <= `EXE_RES_ARITHMETIC; 
                        reg1_ren_o  <= 1'b1;	
                        reg2_ren_o  <= 1'b0;	  	
                        inst_vld    <= `InstValid;	
                        end
                    `EXE_CLO:begin
                        wreg_o      <= `WriteEnable; 
                        aluop_o     <= `EXE_CLO_OP;
                        alusel_o    <= `EXE_RES_ARITHMETIC; 
                        reg1_ren_o  <= 1'b1;	
                        reg2_ren_o  <= 1'b0;	  	
                        inst_vld    <= `InstValid;	
                        end
                    `EXE_MUL:   begin
                        wreg_o      <= `WriteEnable; 
                        aluop_o     <= `EXE_MUL_OP;
                        alusel_o    <= `EXE_RES_MUL; 
                        reg1_ren_o  <= 1'b1;	
                        reg2_ren_o  <= 1'b1;
                        inst_vld    <= `InstValid;	  
                        end
                    default:	begin
                    end
                endcase      //EXE_SPECIAL_INST2 case
                end  	
            default:begin
            end
            endcase     //case op
    

        if (id_inst_i[31:21] == 11'b00000000000) begin
            if (op3 == `EXE_SLL) begin
                wreg_o      <= `WriteEnable;
                aluop_o     <= `EXE_SLL_OP;
                alusel_o    <= `EXE_RES_SHIFT;
                reg1_ren_o  <= 1'b0;
                reg2_ren_o  <= 1'b1;
                imm[4:0]    <= id_inst_i[10:6];
                w_addr_o    <= id_inst_i[15:11];
                inst_vld    <= `InstValid;
            end else if ( op3 == `EXE_SRL ) begin
                wreg_o      <= `WriteEnable;
                aluop_o     <= `EXE_SRL_OP;
                alusel_o    <= `EXE_RES_SHIFT;
                reg1_ren_o  <= 1'b0;
                reg2_ren_o  <= 1'b1;
                imm[4:0]    <= id_inst_i[10:6];
                w_addr_o    <= id_inst_i[15:11];
                inst_vld    <= `InstValid;
            end else if ( op3 == `EXE_SRA ) begin
                wreg_o      <= `WriteEnable;
                aluop_o     <= `EXE_SRA_OP;
                alusel_o    <= `EXE_RES_SHIFT;
                reg1_ren_o  <= 1'b0;
                reg2_ren_o  <= 1'b1;
                imm[4:0]    <= id_inst_i[10:6];
                w_addr_o    <= id_inst_i[15:11];
                inst_vld    <= `InstValid;
                end
            end   	  
    end 
end 

always_comb begin
    if(rst == `RstEnable) begin
        reg1_data_o <= `ZeroWord;
    end else if(reg1_ren_o == 1'b1 && ex_wreg_i == 1'b1 && ex_waddr_i == reg1_addr_o) begin
        reg1_data_o <= ex_wdata_i;  //Regfile读端口1的输出值
    end else if(reg1_ren_o == 1'b1 && mem_wreg_i == 1'b1 && mem_waddr_i == reg1_addr_o) begin
        reg1_data_o <= mem_wdata_i;  //Regfile读端口1的输出值
    end else if(reg1_ren_o == 1'b1) begin
        reg1_data_o <= reg1_data_i;  //Regfile读端口1的输出值
    end else if(reg1_ren_o == 1'b0) begin
        reg1_data_o <= imm;          //立即数
    end else begin
        reg1_data_o <= `ZeroWord;
    end
end

always_comb begin
    if(rst == `RstEnable) begin
        reg2_data_o <= `ZeroWord;
    end else if(reg2_ren_o == 1'b1 && ex_wreg_i == 1'b1 && ex_waddr_i == reg2_addr_o) begin
        reg2_data_o <= ex_wdata_i;  //Regfile读端口1的输出值
    end else if(reg2_ren_o == 1'b1 && mem_wreg_i == 1'b1 && mem_waddr_i == reg2_addr_o) begin
        reg2_data_o <= mem_wdata_i;  //Regfile读端口1的输出值
    end else if(reg2_ren_o == 1'b1) begin
        reg2_data_o <= reg2_data_i;  //Regfile读端口1的输出值
    end else if(reg2_ren_o == 1'b0) begin
        reg2_data_o <= imm;          //立即数
    end else begin
        reg2_data_o <= `ZeroWord;
    end
end


endmodule