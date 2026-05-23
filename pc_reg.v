//  PC寄存器模块
//  负责存储程序计数器的值，并根据时钟信号更新程序计数器的值，同时控制芯片使能信号
`include "defines.v"

module pc_reg(
  input wire clk, //时钟信号
  input wire rst, //复位信号
  output reg[`Inst_Addr_Bus]  pc_o,  // 程序计数器
  output reg          ce_o   // 芯片使能信号
);

  // 程序计数器寄存器
    always @ (posedge clk) begin
        if (ce_o == `Chip_DIS) begin
            pc_o <= `Word_Zero;
        end else begin
            pc_o <= pc_o + 4'h4;
        end
    end
  
  // 芯片使能信号
    always @ (posedge clk, posedge rst) begin
        if (rst == `Rst_EN) begin
            ce_o <= `Chip_DIS;
        end else begin
            ce_o <= `Chip_EN;
        end
    end
    
endmodule