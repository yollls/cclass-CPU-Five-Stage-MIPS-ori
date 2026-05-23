//  MEM阶段模块
// 负责处理内存访问指令，并将结果传递给MEM/WB寄存器
`include "defines.v"

module memory (
    input wire                  rst,
    input wire[`Reg_Addr_Bus]   wd_i,   // 目的寄存器地址
    input wire                  wreg_i, // 是否写目的寄存器
    input wire[`Reg_Bus]        wdata_i,    // 写目的寄存器的数据

    output reg[`Reg_Addr_Bus]   wd_o,   // 目的寄存器地址
    output reg                  wreg_o, // 是否写目的寄存器
    output reg[`Reg_Bus]        wdata_o    // 写目的寄存器的数据

);

 
  //访存阶段的输出

  always @ (*) begin
    if(rst == `Rst_EN) begin
      wd_o <= `NOP_Reg_Addr;
      wreg_o <= `Write_DIS;
      wdata_o <= `Word_Zero;
    end else begin
      wd_o <= wd_i;
      wreg_o <= wreg_i;
      wdata_o <= wdata_i;
    end

  end 
  
endmodule