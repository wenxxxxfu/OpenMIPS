module regfile #(
    parameter RegAddrBus = 32,
    parameter RegBus     = 32,
    parameter RegNum     = 32
)(
    input  logic                        clk,
    input  logic                        rst_n,
    
    //write
    input  logic                        wen,
    input  logic   [RegAddrBus-1: 0]    waddr,
    output logic   [RegBus    -1: 0]    wdata,

    //read1
    input  logic                        ren1,
    input  logic   [RegAddrBus-1: 0]    raddr1,
    output logic   [RegBus    -1: 0]    rdata1,

    //read2
    input  logic                        ren2,
    input  logic   [RegAddrBus-1: 0]    raddr2,
    output logic   [RegBus    -1: 0]    rdata2
);

reg [RegBus-1:0] regs [0:RegNum-1];

integer i;

//sequantial logic
always_ff @( posedge clk or negedge rst) begin 
    if(!rst_n) begin
        for(i = 0; i < RegNum ;i = i + 1) begin
            regs[i] <= 'b0;
        end
    end else if(wen && waddr!='b0) begin
        regs[waddr] <= wdata;
    end  
end

//comb_logic, when address change, output data of new address 
always_comb begin 
    if(!rst_n) begin
        rdata1 <= 'b0;
    end else if(raddr1=='b0) begin
        rdata1 <= 'b0;
    end  else if(wen && ren1 && raddr1 == waddr) begin
        rdata1 <= wdata;
    end else if(ren1) begin
        rdata1 <= regs[raddr1];
    end  else begin
        rdata1 <= 'b0;
    end
end

always_comb  begin 
    if(!rst_n) begin
        rdata2 <= 'b0;
    end else if(raddr2=='b0) begin
        rdata2 <= 'b0;
    end  else if(wen && ren2 && raddr2 == waddr) begin
        rdata2 <= wdata;
    end else if(ren2) begin
        rdata2 <= regs[raddr2];
    end  else begin
        rdata2 <= 'b0;
    end
end

endmodule