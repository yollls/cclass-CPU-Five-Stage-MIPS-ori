//  EX/MEM寄存器模块
// 负责将EX阶段的结果传递给MEM阶段
`include "defines.v"

module ex_mem (
    input wire                  clk,
    input wire                  rst,

    input wire[`Reg_Addr_Bus]   wd_i,   // 目的寄存器地址
    input wire                  wreg_i, // 是否写目的寄存器
    input wire[`Reg_Bus]        wdata_i,    // 写目的寄存器的数据

    output reg[`Reg_Addr_Bus]   wd_o,   // 目的寄存器地址
    output reg                  wreg_o, // 是否写目的寄存器
    output reg[`Reg_Bus]        wdata_o    // 写目的寄存器的数据

);
 
    always @ (posedge clk, posedge rst) begin
        if (rst == `Rst_EN) begin
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