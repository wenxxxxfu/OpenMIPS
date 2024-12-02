`include "defines.sv"
`timescale 1ns/1ps
module gen_pc_reg(
    input   logic                   clk,
    input   logic                   rst,
    
    output  logic   [`InstAddrBus]  gen_pc, 
    output  logic                   gen_pc_vld 

);

always_ff @( posedge clk) begin 
    if(rst==`RstEnable) begin
        gen_pc_vld <= `ChipDisable;
    end else begin
        gen_pc_vld <= `ChipEnable;
    end
    
end

always_ff @( posedge clk) begin 
    if(gen_pc_vld==`ChipDisable) begin
        gen_pc <= 'h0;
    end else begin
        gen_pc <= gen_pc + 4'h4;
    end
    
end

endmodule