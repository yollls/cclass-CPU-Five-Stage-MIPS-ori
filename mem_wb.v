//  MEM/WB寄存器模块
// 负责将MEM阶段的结果传递给WB阶段
`include "defines.v"

module mem_wb (
    input wire                  clk,
    input wire                  rst,

    input wire[`Reg_Addr_Bus]   wd_i,
    input wire                  wreg_i,
    input wire[`Reg_Bus]        wdata_i,
    
    output reg[`Reg_Addr_Bus]   wd_o,
    output reg                  wreg_o,
    output reg[`Reg_Bus]        wdata_o

);

  // MEM/WB寄存器
    always @ (posedge clk, posedge rst) begin
        if (rst == `Rst_EN) begin
            wd_o <= `Word_Zero;
            wdata_o <= `Word_Zero;
            wreg_o <= `Write_DIS;
        end else begin
            wd_o <= wd_i;
            wdata_o <= wdata_i;
            wreg_o <= wreg_i;
        end
    end
endmodule