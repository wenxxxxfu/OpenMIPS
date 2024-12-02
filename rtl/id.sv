`include "defines.sv"
`timescale 1ns/1ps
module id(
    input  logic                   rst,
    input  logic   [`InstAddrBus]  id_pc_i,
    input  logic   [`InstBus    ]  id_inst_i,
    
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
logic[`RegBus] imm;

assign op  = id_inst_i[31:26];

always_comb begin
    if(rst == `RstEnable) begin
        aluop_o     <=  `EXE_NOP_OP;
        alusel_o    <=  `EXE_RES_NOP;
        w_addr_o    <=  `NOPRegAddr;
        wreg_o      <=  `WriteDisable;
        inst_vld    <=  `InstInvalid;
        reg1_ren_o <=  1'b0;
        reg2_ren_o <=  1'b0;
        reg1_addr_o <=  `NOPRegAddr;
        reg2_addr_o <=  `NOPRegAddr;
        imm         <=  32'h0;
    end else begin
        aluop_o     <=  `EXE_NOP_OP;
        alusel_o    <=  `EXE_RES_NOP;
        w_addr_o    <=  id_inst_i[15:11];
        wreg_o      <=  `WriteDisable;
        inst_vld    <=  `InstInvalid;
        reg1_ren_o <=  1'b0;
        reg2_ren_o <=  1'b0;
        reg1_addr_o <=  id_inst_i[25:21];  
        reg2_addr_o <=  id_inst_i[20:16]; 
        imm         <=  `ZeroWord;    

        case(op)
            `EXE_ORI:   begin   
            wreg_o      <=  `WriteEnable;
            aluop_o     <=  `EXE_OR_OP;  
            alusel_o    <=  `EXE_RES_LOGIC;
            reg1_ren_o <=  1'b1;
            reg2_ren_o <=  1'b0;
            imm         <=  {16'h0,id_inst_i[15:0]};
            w_addr_o    <=  id_inst_i[20:16];
            inst_vld    <=  `InstValid;
            end
            default:begin
            end
        endcase 
    end 
end 

always_comb begin
    if(rst == `RstEnable) begin
        reg1_data_o <= `ZeroWord;
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
    end else if(reg2_ren_o == 1'b1) begin
        reg2_data_o <= reg2_data_i;  //Regfile读端口1的输出值
    end else if(reg2_ren_o == 1'b0) begin
        reg2_data_o <= imm;          //立即数
    end else begin
        reg2_data_o <= `ZeroWord;
    end
end


endmodule