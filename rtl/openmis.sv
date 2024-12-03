`include "defines.sv"
`timescale 1ns/1ps
module openmips(
	input  logic             clk,
	input  logic             rst,
	input  logic[`RegBus]    rom_data_i,
	output logic[`RegBus]    rom_addr_o,
	output logic             rom_ce_o
	
);

    logic[`InstAddrBus] gen_pc_i;
    logic[`InstAddrBus] id_pc_i;
    logic[`InstBus]     id_inst_i;

    //连接译码阶段ID模块的输出与ID/EX模块的输入
	logic[`AluOpBus]    id_aluop_o;
	logic[`AluSelBus]   id_alusel_o;
	logic[`RegBus]      id_reg1_data_o;
	logic[`RegBus]      id_reg2_data_o;
	logic               id_wreg_o;
	logic[`RegAddrBus]  id_waddr_o;

    //连接ID/EX模块的输出与执行阶段EX模块的输入
	logic[`AluOpBus]    ex_aluop_i;
	logic[`AluSelBus]   ex_alusel_i;
	logic[`RegBus]      ex_reg1_data_i;
	logic[`RegBus]      ex_reg2_data_i;
	logic               ex_wreg_i;
	logic[`RegAddrBus]  ex_waddr_i;

    //连接执行阶段EX模块的输出与EX/MEM模块的输入
	logic               ex_wreg_o;
	logic[`RegAddrBus]  ex_waddr_o;
	logic[`RegBus]      ex_wdata_o;

	//连接EX/MEM模块的输出与访存阶段MEM模块的输入
	logic               mem_wreg_i;
	logic[`RegAddrBus]  mem_waddr_i;
	logic[`RegBus]      mem_wdata_i;

	//连接访存阶段MEM模块的输出与MEM/WB模块的输入
	logic               mem_wreg_o;
	logic[`RegAddrBus]  mem_waddr_o;
	logic[`RegBus]      mem_wdata_o;
	
	//连接MEM/WB模块的输出与回写阶段的输入	
	logic               wb_wreg_i;
	logic[`RegAddrBus]  wb_waddr_i;
	logic[`RegBus]      wb_wdata_i;
	
	//连接译码阶段ID模块与通用寄存器Regfile模块
    logic               reg1_ren;
    logic               reg2_ren;
    logic[`RegBus]      reg1_data;
    logic[`RegBus]      reg2_data;
    logic[`RegAddrBus]  reg1_addr;
    logic[`RegAddrBus]  reg2_addr;
    
    //pc_reg例化
	gen_pc_reg pc_reg0(
		.clk        (clk),
		.rst        (rst),
		.gen_pc     (gen_pc_i),
		.gen_pc_vld (rom_ce_o)			
	);
	
  assign rom_addr_o = gen_pc_i;


    //IF/ID模块例化
	if_id if_id0(
		.clk        (clk),
		.rst        (rst),
		.if_pc_i    (gen_pc_i),
		.if_inst_i  (rom_data_i),
		.id_pc_o    (id_pc_i),
		.id_inst_o  (id_inst_i)      	
	);

    //译码阶段ID模块
	id id0(
		.rst        (rst),
		.id_pc_i    (id_pc_i),
		.id_inst_i  (id_inst_i),
		.reg1_data_i(reg1_data),
		.reg2_data_i(reg2_data),

        		
        .ex_wreg_i      (ex_wreg_o),
        .ex_wdata_i     (ex_wdata_o),
        .ex_waddr_i     (ex_waddr_o),
        .mem_wreg_i     (mem_wreg_o),
        .mem_wdata_i    (mem_wdata_o),
        .mem_waddr_i    (mem_waddr_o),


		//送到regfile的信息
		.reg1_ren_o (reg1_ren),
		.reg2_ren_o (reg2_ren), 	  
		.reg1_addr_o(reg1_addr),
		.reg2_addr_o(reg2_addr), 
	  
		//送到ID/EX模块的信息
		.aluop_o    (id_aluop_o),
		.alusel_o   (id_alusel_o),
		.reg1_data_o(id_reg1_data_o),
		.reg2_data_o(id_reg2_data_o),
		.w_addr_o   (id_waddr_o),
		.wreg_o     (id_wreg_o)
	);


    //ID/EX模块
	id_ex id_ex0(
		.clk            (clk),
		.rst            (rst),


		//从译码阶段ID模块传递的信息
		.id_aluop       (id_aluop_o),
		.id_alusel      (id_alusel_o),
		.id_reg1_data   (id_reg1_data_o),
		.id_reg2_data   (id_reg2_data_o),
		.id_waddr       (id_waddr_o),
		.id_wreg        (id_wreg_o),
	
		//传递到执行阶段EX模块的信息
		.ex_aluop       (ex_aluop_i),
		.ex_alusel      (ex_alusel_i),
		.ex_reg1_data   (ex_reg1_data_i),
		.ex_reg2_data   (ex_reg2_data_i),
		.ex_waddr       (ex_waddr_i),
		.ex_wreg        (ex_wreg_i)
	);	

	//EX模块
	ex ex0(
		.rst        (rst),
	
		//送到执行阶段EX模块的信息
		.aluop_i    (ex_aluop_i),
		.alusel_i   (ex_alusel_i),
		.reg1_data_i(ex_reg1_data_i),
		.reg2_data_i(ex_reg2_data_i),
		.waddr_i    (ex_waddr_i),
		.wreg_i     (ex_wreg_i),
	  
	     //EX模块的输出到EX/MEM模块信息
		.waddr_o    (ex_waddr_o),
		.wreg_o     (ex_wreg_o),
		.wdata_o    (ex_wdata_o)
		
	);
	
    //EX/MEM模块
  ex_mem ex_mem0(
		.clk        (clk),
		.rst        (rst),
	  
		//来自执行阶段EX模块的信息	
		.ex_waddr   (ex_waddr_o),
		.ex_wreg    (ex_wreg_o),
		.ex_wdata   (ex_wdata_o),
	
		//送到访存阶段MEM模块的信息
		.mem_waddr  (mem_waddr_i),
		.mem_wreg   (mem_wreg_i),
		.mem_wdata  (mem_wdata_i)				       	
	);

    	
  //MEM模块例化
	mem mem0(
		.rst        (rst),
	
		//来自EX/MEM模块的信息	
		.waddr_i    (mem_waddr_i),
		.wreg_i     (mem_wreg_i),
		.wdata_i    (mem_wdata_i),
	  
		//送到MEM/WB模块的信息
		.waddr_o    (mem_waddr_o),
		.wreg_o     (mem_wreg_o),
		.wdata_o    (mem_wdata_o)
	);

  //MEM/WB模块
	mem_wb mem_wb0(
		.clk            (clk),
		.rst            (rst),

		//来自访存阶段MEM模块的信息	
		.mem_waddr      (mem_waddr_o),
		.mem_wreg       (mem_wreg_o),
		.mem_wdata      (mem_wdata_o),
	
		//送到回写阶段的信息
		.wb_waddr       (wb_waddr_i),
		.wb_wreg        (wb_wreg_i),
		.wb_wdata       (wb_wdata_i)
									       	
	);


  //通用寄存器Regfile例化
	regfile regfile1(
		.clk        (clk),
		.rst        (rst),
		.wen        (wb_wreg_i),
		.waddr      (wb_waddr_i),
		.wdata      (wb_wdata_i),
		.ren1       (reg1_ren),
		.raddr1     (reg1_addr),
		.rdata1     (reg1_data),
		.ren2        (reg2_ren),
		.raddr2     (reg2_addr),
		.rdata2     (reg2_data)
	);

		


 


endmodule