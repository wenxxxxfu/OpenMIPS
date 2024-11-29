module if_id #(
    parameter InstAddrBus = 32,
    parameter InstBus     = 32
)(
    input   logic                      clk,
    input   logic                      rst_n,
    input   logic   [InstAddrBus-1: 0] if_pc_i,
    input   logic   [InstBus    -1: 0] if_inst_i,

    output  logic   [InstAddrBus-1: 0] id_pc_o,
    output  logic   [InstBus    -1: 0] id_inst_o


);

always_ff @( posedge clk or negedge rst) begin 
    if(!rst_n) begin
        id_pc_o <= 32'h0;
    end else begin
        id_pc_o <= if_pc_i;
    end
    
end

always_ff @( posedge clk or negedge rst) begin 
    if(!rst_n) begin
        id_inst_o <= 32'h0;
    end else begin
        id_pc_o <= if_pc_i;
    end
    
end

endmodule