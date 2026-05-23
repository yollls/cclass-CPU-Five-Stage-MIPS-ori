//  指令译码模块
//  负责将取指阶段传递过来的指令进行译码，生成相应的控制信号和操作数，并传递给ID/EX寄存器
`include "defines.v"

module inst_decode (

  input wire              rst,
  input wire[`Inst_Addr_Bus]    pc_i,
  input wire[`Inst_Bus]      inst_i,
  
  input wire[`Reg_Bus]       reg1_data_i,
  input wire[`Reg_Bus]       reg2_data_i,

  output reg            reg1_read_o,
  output reg            reg2_read_o,
  output reg[`Reg_Addr_Bus]    reg1_addr_o,
  output reg[`Reg_Addr_Bus]    reg2_addr_o,

  output reg[`Alu_Op_Bus]     alu_op_o,
  output reg[`Alu_Sel_Bus]     alu_sel_o,
  output reg[`Reg_Bus]       reg1_o,
  output reg[`Reg_Bus]       reg2_o,
  output reg[`Reg_Addr_Bus]    wd_o, // 写回目标寄存器地址输出

  output reg            wreg_o // 寄存器写使能输出

);

  wire [5:0] op1 = inst_i[31:26];
  wire [4:0] op2 = inst_i[10:6]; // R 型指令中shamt 字段
  wire [5:0] op3 = inst_i[5:0]; // R 型指令中funct 字段
  wire [4:0] op4 = inst_i[20:16]; // R 型或 I 型指令中rt 字段

  reg[`Reg_Bus] imm; // 立即数
  reg inst_valid;

    always @ (*) begin
        wreg_o = `Write_DIS;
        wd_o = `NOP_Reg_Addr;
        alu_op_o = `EXE_NOP_OP;
        alu_sel_o = `EXE_RES_NOP;
        reg1_read_o = `Read_DIS;
        reg2_read_o = `Read_DIS;
        imm = `Word_Zero;
        inst_valid = `Inst_Invalid;
        reg1_addr_o = inst_i[25:21];
        reg2_addr_o = inst_i[20:16];

        case(op1)
			  `EXE_ORI: begin
                wreg_o = `Write_EN;
                alu_op_o = `EXE_OR_OP;
                alu_sel_o = `EXE_RES_LOGIC;
                reg1_read_o = `Read_EN;
                reg2_read_o = `Read_DIS;
                reg1_addr_o = inst_i[25:21];
                imm = {16'h0, inst_i[15:0]};
                wd_o = inst_i[20:16];
                inst_valid = `Inst_Valid;
            end
            default: begin
            end
        endcase  

  end

  

 

  always @ (*) begin    //读寄存器1的值
    if(rst == `Read_EN) begin
      reg1_o <= `Word_Zero;
    end else if(reg1_read_o == `Read_EN) begin
      reg1_o <= reg1_data_i;
    end else if(reg1_read_o == `Read_DIS) begin
      reg1_o <= imm;
    end else begin
      reg1_o <= `Word_Zero;
    end

  end

  

  always @ (*) begin    //读寄存器2的值
    if(rst == `Read_EN) begin
      reg2_o <= `Word_Zero;
    end else if(reg2_read_o == `Read_EN) begin
      reg2_o <= reg2_data_i;
    end else if(reg2_read_o == `Read_DIS) begin
      reg2_o <= imm;
    end else begin
      reg2_o <= `Word_Zero;
    end

  end

endmodule