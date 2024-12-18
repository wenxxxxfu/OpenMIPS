`include "defines.sv"
`timescale 1ns/1ps


module openmips_min_sopc_tb();

  reg     CLOCK_50;
  reg     rst;
  
       
  initial begin
    CLOCK_50 = 1'b0;
    forever #10 CLOCK_50 = ~CLOCK_50;
  end
      
  initial begin
    rst = `RstEnable;
    #195 rst= `RstDisable;
    #1000 $finish;
  end
       
  openmips_min_sopc openmips_min_sopc0(
		.clk(CLOCK_50),
		.rst(rst)	
	);
    initial	begin
        $fsdbDumpfile("./wave/arithmetic.fsdb");//这个是产生名为tb.fsdb的文件
        $fsdbDumpMDA();
        $fsdbDumpvars;
    end
endmodule