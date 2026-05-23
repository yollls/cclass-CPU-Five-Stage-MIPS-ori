//  ID/EX寄存器模块
// 负责将ID阶段的信息传递给EX阶段
`include "defines.v"

module id_ex(

  input wire            clk,
  input wire            rst,

  input wire[`Alu_Op_Bus]     alu_op_i,
  input wire[`Alu_Sel_Bus]     alu_sel_i,

  input wire[`Reg_Bus]       reg1_i,
  input wire[`Reg_Bus]       reg2_i,

  input wire[`Reg_Addr_Bus]    wd_i, 
  input wire            wreg_i,

  //传递到执行阶段的信息
  output reg[`Alu_Op_Bus]     alu_op_o,
  output reg[`Alu_Sel_Bus]     alu_sel_o,
  output reg[`Reg_Bus]       reg1_o,
  output reg[`Reg_Bus]       reg2_o,
  output reg[`Reg_Addr_Bus]    wd_o, 
  output reg            wreg_o

);


  // ID/EX寄存器

  always @ (posedge clk, posedge rst) begin
    if (rst == `Rst_EN) begin
      alu_op_o <= `EXE_NOP_OP;
      alu_sel_o <= `EXE_RES_NOP;
      wd_o <= `NOP_Reg_Addr;
      wreg_o <= `Write_DIS;
      reg1_o <= `Word_Zero;
      reg2_o <= `Word_Zero;
    end else begin    
      alu_op_o <= alu_op_i;
      alu_sel_o <= alu_sel_i;
      wd_o <= wd_i;
      wreg_o <= wreg_i;
      reg1_o <= reg1_i;
      reg2_o <= reg2_i;
    end
  end

endmodule