//  写回阶段模块
//  负责将执行阶段或内存访问阶段的结果写回寄存器文件，并传递给下一个指令使用
`include "defines.v"

module write_back(
    input wire[`Reg_Addr_Bus]       wd_i,
    input wire                      wreg_i,
    input wire[`Reg_Bus]            wdata_i,

    output reg[`Reg_Addr_Bus]       wb_wd,
    output reg                      wb_wreg,
    output reg[`Reg_Bus]            wb_wdata
);

    always @ (*) begin
        wb_wd = wd_i;
        wb_wreg = wreg_i;
        wb_wdata = wdata_i;
    end
endmodule