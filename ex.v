//  EX阶段模块
// 负责执行指令的运算，并将结果传递给EX/MEM寄存器
`include "defines.v"

module execute(
    input wire                  clk,    // 时钟信号
    input wire                  rst,    // 复位信号
    input wire[`Alu_Op_Bus]     alu_op_i,   // 来自译码阶段的 ALU 操作类型
    input wire[`Alu_Sel_Bus]    alu_sel_i,  // 来自译码阶段的 ALU 结果选择信号
    input wire[`Reg_Bus]        reg1_i, // 来自译码阶段的第一个操作数
    input wire[`Reg_Bus]        reg2_i, // 来自译码阶段的第二个操作数
    input wire[`Reg_Addr_Bus]   wd_i,   // 来自译码阶段的目的寄存器地址
    input wire                  wreg_i, // 来自译码阶段的写寄存器使能信号

    
    output reg[`Reg_Addr_Bus]   wd_o,   // 送到写回阶段的目的寄存器地址
    output reg                  wreg_o, // 送到写回阶段的写寄存器使能信号
    output reg[`Reg_Bus]        wdata_o    // 送到写回阶段的写寄存器数据

);

  reg[`Reg_Bus] logic_out;  //逻辑运算结果

    // ALU 逻辑运算
    always @ (*) begin
        case(alu_op_i)
            `EXE_OR_OP: begin
                logic_out = reg1_i | reg2_i;
            end
            default: begin
                logic_out = `Word_Zero;
            end
        endcase
    end

    // 根据并行 ALU 子结果选择写回
    always @ (*) begin
        wd_o = wd_i;
        wreg_o = wreg_i;
        case(alu_sel_i)
            `EXE_RES_LOGIC: begin
                wdata_o = logic_out;
            end
            default: begin
                wdata_o = `Word_Zero;
            end
        endcase
    end

endmodule