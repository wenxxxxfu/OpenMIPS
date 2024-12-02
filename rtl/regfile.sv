`include "defines.sv"
`timescale 1ns/1ps
module regfile (
    input  logic                    clk,
    input  logic                    rst,
    
    //write
    input  logic                    wen,
    input  logic   [`RegAddrBus]    waddr,
    input logic   [`RegBus    ]     wdata,

    //read1
    input  logic                    ren1,
    input  logic   [`RegAddrBus]    raddr1,
    output logic   [`RegBus    ]    rdata1,

    //read2
    input  logic                    ren2,
    input  logic   [`RegAddrBus]    raddr2,
    output logic   [`RegBus    ]    rdata2
);

reg [`RegBus] regs [0:`RegNum-1];

integer i;

//sequantial logic
always_ff @( posedge clk) begin 
    if(rst==`RstDisable) begin
        if(wen==`WriteEnable && waddr!='h0) begin
            regs[waddr] <= wdata;
        end  
    end
end

//comb_logic, when address change, output data of new address 
always_comb begin 
    if(rst==`RstEnable) begin
        rdata1 <= `ZeroWord;
    end else if(raddr1=='b0) begin
        rdata1 <= `ZeroWord;
    end  else if(wen ==`WriteEnable&& ren1==`ReadEnable && raddr1 == waddr) begin
        rdata1 <= wdata;
    end else if(ren1==`ReadEnable) begin
        rdata1 <= regs[raddr1];
    end  else begin
        rdata1 <= `ZeroWord;
    end
end

always_comb  begin 
    if(rst==`RstEnable) begin
        rdata2 <= `ZeroWord;
    end else if(raddr2=='b0) begin
        rdata2 <= `ZeroWord;
    end  else if(wen ==`WriteEnable&& ren2==`ReadEnable && raddr2 == waddr) begin
        rdata2 <= wdata;
    end else if(ren2==`ReadEnable) begin
        rdata2 <= regs[raddr2];
    end  else begin
        rdata2 <= `ZeroWord;
    end
end

endmodule