//  IF/ID寄存器模块
// 负责将IF阶段的信息传递给ID阶段
`include "defines.v"

module if_id(

  input wire clk,
  input wire rst,
  input wire[`Inst_Addr_Bus]  pc_i,
  input wire[`Inst_Bus]    inst_i,

  output reg[`Inst_Addr_Bus]  pc_o,
  output reg[`Inst_Bus]    inst_o 

);

  // IF/ID寄存器
    always @ (posedge clk, posedge rst) begin
        if (rst == `Rst_EN) begin
            pc_o <= `Word_Zero;
            inst_o <= `Word_Zero;
        end else begin
            pc_o <= pc_i;
            inst_o <= inst_i;
        end
    end

endmodule