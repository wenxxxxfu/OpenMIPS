`include "defines.sv"

module hilo_reg(

    input   wire        clk,
    input   wire        rst,
	
    //写端口
    input wire          we,
    input wire[`RegBus] hi_i,
    input wire[`RegBus] lo_i,
	
	//读端口1
    output reg[`RegBus] hi_o,
    output reg[`RegBus] lo_o
	
);

    always_ff @ (posedge clk) begin
        if (rst == `RstEnable) begin
            hi_o <= `ZeroWord;
            lo_o <= `ZeroWord;
        end else if((we == `WriteEnable)) begin
            hi_o <= hi_i;
            lo_o <= lo_i;
        end
    end

endmodule