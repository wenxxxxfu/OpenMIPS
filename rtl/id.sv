module id #(
    parameter InstAddrBus = 32,
    parameter InstBus     = 32,
    parameter RegAddrBus  = 32,
    parameter RegBus      = 32,
    parameter RegNum      = 32,
    parameter AluOpBus    = 8,
    parameter AluSelBus   = 3
)(
    input  logic                      rst_n,
    input  logic   [InstAddrBus-1: 0] id_pc_i,
    input  logic   [InstBus    -1: 0] id_inst_i,
    
    //regfile
    input  logic   [RegBus    -1: 0]  reg1_data_i,
    input  logic   [RegBus    -1: 0]  reg2_data_i,
    output logic                      reg1_ren_o,
    output logic                      reg2_ren_o,
    output logic   [RegAddrBus-1: 0]  reg1_addr_o,
    output logic   [RegAddrBus-1: 0]  reg2_addr_o,

    //exe
    output logic   [AluOpBus-1  : 0]  aluop_o,
    output logic   [AluSelBus-1 : 0]  alusel_o,
    output logic   [RegBus    -1: 0]  reg1_data_o,
    output logic   [RegBus    -1: 0]  reg2_data_o,
    output logic   [RegAddrBus-1: 0]  w_addr_o,
    output logic                      wreg_o, //whether
);





endmodule