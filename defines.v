// 全局常量
`define Word_LEN       32   // 字长
`define Word_Zero      `Word_LEN'h00000000   // 全零值
`define True_v        1'b1   // 真值
`define False_v       1'b0   // 假值
`define Inst_Valid      1'b0    // 指令有效
`define Inst_Invalid     1'b1   // 指令无效
`define Alu_Op_Bus      7:0     // ALU操作码总线宽度
`define Alu_Sel_Bus     2:0     // ALU操作选择总线宽度

// 使能信号
`define Rst_EN        1'b1  // 复位使能
`define Rst_DIS       1'b0  // 复位禁止
`define Write_EN       1'b1 // 写使能
`define Write_DIS      1'b0 // 写禁止
`define Read_EN       1'b1  // 读使能
`define Read_DIS       1'b0 // 读禁止
`define Chip_EN       1'b1  // 芯片使能
`define Chip_DIS       1'b0 // 芯片禁止

//指令
`define EXE_ORI 6'b001101   // ori 指令的 opcode 字段
`define EXE_NOP  6'b000000  // nop 指令的 opcode 字段

//AluOp
`define EXE_NOP_OP 8'b00000000  // 空操作
`define EXE_OR_OP  8'b00100101  // OR 操作
`define EXE_ORI_OP 8'b01011010  // ORI 操作

//AluSel
`define EXE_RES_LOGIC 3'b001    // 逻辑运算结果
`define EXE_RES_NOP 3'b000      // 空操作结果
//指令存储器inst_rom
`define Inst_Addr_Bus 31:0   //ROM的地址线宽度
`define Inst_Bus 31:0   //ROM的数据线宽度
`define Inst_Mem_Num 131071  //ROM的实际大小为128KB,共131071条指令
`define Inst_Mem_Num_Log2 17  //ROM大小的对数

//通用寄存器regfile
`define Reg_Width      32  // 寄存器宽度
`define Reg_Bus       31:0   // 寄存器总线宽度
`define Reg_Addr_Bus     4:0   // 寄存器地址宽度
`define Reg_Num       32    // 寄存器数量
`define Reg_Num_Log2     5    // 2^5 = 32
`define Double_Reg_Width   64    // 双寄存器宽度
`define Double_Reg_Bus    63:0   // 双寄存器总线宽度
`define NOP_Reg_Addr     5'b00000   // $zero 寄存器地址