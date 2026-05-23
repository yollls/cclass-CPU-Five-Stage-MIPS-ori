//  CPU顶层模块
// 连接各个模块，形成一个完整的CPU设计
`include "defines.v"

module cpu(
    input wire                  clk,
    input wire                  rst,
    input wire[`Reg_Bus]        rom_data_i, // 从ROM读取的数据
    output wire[`Reg_Bus]       rom_addr_o, // ROM地址输出

    output wire                 rom_ce_o   // ROM使能信号

);

  wire[`Inst_Addr_Bus]        pc;
  wire[`Inst_Addr_Bus]        id_pc_i;
  wire[`Inst_Bus]             id_inst_i;
  
  //连接译码阶段ID模块的输出与ID/EX模块的输入
  wire[`Alu_Op_Bus]           id_alu_op_o;
  wire[`Alu_Sel_Bus]          id_alu_sel_o;
  wire[`Reg_Bus]              id_reg1_o;
  wire[`Reg_Bus]              id_reg2_o;
  wire                        id_wreg_o;
  wire[`Reg_Addr_Bus]         id_wd_o;

  //连接ID/EX模块的输出与执行阶段EX模块的输入
  wire[`Alu_Op_Bus]           ex_alu_op_i;
  wire[`Alu_Sel_Bus]          ex_alu_sel_i;
  wire[`Reg_Bus]              ex_reg1_i;
  wire[`Reg_Bus]              ex_reg2_i;
  wire                        ex_wreg_i;
  wire[`Reg_Addr_Bus]         ex_wd_i; 
  
  //连接执行阶段EX模块的输出与EX/MEM模块的输入
  wire                        ex_wreg_o;  // 是否写目的寄存器
  wire[`Reg_Bus]              ex_wdata_o; // 写目的寄存器的数据
  wire[`Reg_Addr_Bus]         ex_wd_o;    // 目的寄存器地址

  //连接EX/MEM模块的输出与访存阶段MEM模块的输入
  wire                        mem_wreg_i;
  wire[`Reg_Bus]              mem_wdata_i;
  wire[`Reg_Addr_Bus]         mem_wd_i;

  //连接访存阶段MEM模块的输出与MEM/WB模块的输入
  wire                        mem_wreg_o;
  wire[`Reg_Bus]              mem_wdata_o;
  wire[`Reg_Addr_Bus]         mem_wd_o;

  //连接MEM/WB模块的输出与回写阶段的输入  
  wire[`Reg_Addr_Bus]         wb_wd_i;
  wire                        wb_wreg_i;
  wire[`Reg_Bus]              wb_wdata_i;

  //连接回写阶段输出与Regfile写端口
  wire[`Reg_Addr_Bus]         wb_wd;
  wire                        wb_wreg;
  wire[`Reg_Bus]              wb_wdata;

  //连接译码阶段ID模块与通用寄存器Regfile模块
  wire                        reg1_read;
  wire                        reg2_read;
  wire[`Reg_Bus]              reg1_data;
  wire[`Reg_Bus]              reg2_data;
  wire[`Reg_Addr_Bus]         reg1_addr;
  wire[`Reg_Addr_Bus]         reg2_addr;

  //pc_reg例化
  pc_reg pc_reg (
      .clk(clk),
      .rst(rst),
      .pc_o(pc),
      .ce_o(rom_ce_o)  

  );

  assign rom_addr_o = pc;

  //IF/ID模块例化

  if_id if_id (
      .clk(clk),
      .rst(rst),
      .pc_i(pc),
      .inst_i(rom_data_i),
      .pc_o(id_pc_i),
      .inst_o(id_inst_i)
  );

  //译码阶段ID模块
  inst_decode id (
      .rst(rst),
      .pc_i(id_pc_i),
      .inst_i(id_inst_i),
      .reg1_data_i(reg1_data), .reg2_data_i(reg2_data),
      .reg1_read_o(reg1_read), .reg2_read_o(reg2_read),
      .reg1_addr_o(reg1_addr), .reg2_addr_o(reg2_addr),
      .alu_op_o(id_alu_op_o),
      .alu_sel_o(id_alu_sel_o),

      .reg1_o(id_reg1_o), .reg2_o(id_reg2_o),
      .wd_o(id_wd_o),
      .wreg_o(id_wreg_o)

  );


  //通用寄存器Regfile例化
  regfile regfile(
      .clk(clk),
      .rst(rst),
      .we_i(wb_wreg),
      .waddr_i(wb_wd),
      .wdata_i(wb_wdata),
      .re1_i(reg1_read), .re2_i(reg2_read),
      .raddr1_i(reg1_addr), .raddr2_i(reg2_addr),
      .rdata1_o(reg1_data), .rdata2_o(reg2_data)
  );


  //ID/EX模块
  id_ex id_ex (
      .clk(clk),
      .rst(rst),
      .alu_op_i(id_alu_op_o),
      .alu_sel_i(id_alu_sel_o),
      .reg1_i(id_reg1_o),
      .reg2_i(id_reg2_o),
      .wd_i(id_wd_o),
      .wreg_i(id_wreg_o),

      .alu_op_o(ex_alu_op_i),
      .alu_sel_o(ex_alu_sel_i),
      .reg1_o(ex_reg1_i),
      .reg2_o(ex_reg2_i),
      .wd_o(ex_wd_i),
      .wreg_o(ex_wreg_i)

  );    

  //EX模块
  execute ex (
      .clk(clk),
      .rst(rst),

      .alu_op_i(ex_alu_op_i),
      .alu_sel_i(ex_alu_sel_i),
      .reg1_i(ex_reg1_i), .reg2_i(ex_reg2_i),
      .wd_i(ex_wd_i),
      .wreg_i(ex_wreg_i),
      
      .wd_o(ex_wd_o),
      .wreg_o(ex_wreg_o),
      .wdata_o(ex_wdata_o)

  );

  //EX/MEM模块
  ex_mem ex_mem (
      .clk(clk),
      .rst(rst),
      
      .wd_i(ex_wd_o),
      .wreg_i(ex_wreg_o),
      .wdata_i(ex_wdata_o),

      .wd_o(mem_wd_i),
      .wreg_o(mem_wreg_i),
      .wdata_o(mem_wdata_i)          

  );

  //MEM模块例化
  memory mem (
      .rst(rst),
      .wd_i(mem_wd_i),
      .wreg_i(mem_wreg_i),
      .wdata_i(mem_wdata_i),

      .wd_o(mem_wd_o),
      .wreg_o(mem_wreg_o),
      .wdata_o(mem_wdata_o)
  );

 

  //MEM/WB模块
  mem_wb mem_wb (
      .clk(clk),
      .rst(rst),

      .wd_i(mem_wd_o),
      .wreg_i(mem_wreg_o),
      .wdata_i(mem_wdata_o),

      .wd_o(wb_wd_i),
      .wreg_o(wb_wreg_i),
      .wdata_o(wb_wdata_i)
  );
  
  write_back wb (
    .wd_i(wb_wd_i),
    .wreg_i(wb_wreg_i),
    .wdata_i(wb_wdata_i),

    .wb_wd(wb_wd),
    .wb_wreg(wb_wreg),
    .wb_wdata(wb_wdata)
  );

 

endmodule