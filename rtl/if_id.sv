`include "defines.sv"
`timescale 1ns/1ps
module if_id (
    input   logic                  clk,
    input   logic                  rst,
    input   logic   [`InstAddrBus] if_pc_i,
    input   logic   [`InstBus    ] if_inst_i,

    output  logic   [`InstAddrBus] id_pc_o,
    output  logic   [`InstAddrBus] id_inst_o


);

always_ff @( posedge clk) begin 
    if(rst==`ReadEnable) begin
        id_pc_o <= `ZeroWord;
    end else begin
        id_pc_o <= if_pc_i;
    end
    
end

always_ff @( posedge clk or negedge rst) begin 
    if(rst==`ReadEnable) begin
        id_inst_o <= `ZeroWord;
    end else begin
        id_inst_o <= if_inst_i;
    end
    
end

endmodule