`include "defines.sv"
`timescale 1ns/1ps
module inst_rom(


	input wire                    ce,
	input wire[`InstAddrBus]      addr,
	output reg[`InstBus]          inst
	
);

	reg[`InstBus]  inst_mem[0:`InstMemNum-1];

	initial $readmemh ( "./auto_compile/shift/inst_rom.data", inst_mem );

	always_comb begin
		if (ce == `ChipDisable) begin
			inst <= `ZeroWord;
	  end else begin
		  inst <= inst_mem[addr[`InstMemNumLog2+1:2]];
		end
	end

endmodule