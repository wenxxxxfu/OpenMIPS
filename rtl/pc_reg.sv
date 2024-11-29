module gen_pc_reg #(
    parameter InstAddrBus = 32
)(
    input   logic                       clk,
    input   logic                       rst_n,
    
    output  logic   [InstAddrBus-1: 0]  gen_pc, 
    output  logic                       gen_pc_vld 

);

always_ff @( posedge clk or negedge rst) begin 
    if(!rst_n) begin
        gen_pc_vld <= 'b0;
    end else begin
        gen_pc_vld <= 'b1;
    end
    
end

always_ff  @( posedge clk) begin 
    if(!gen_pc_vld) begin
        gen_pc <= 'h0;
    end else begin
        gen_pc <= gen_pc + 4'h4;
    end
    
end

endmodule