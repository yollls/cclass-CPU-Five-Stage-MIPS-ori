//  指令ROM模块
//  负责存储指令，并根据地址输出相应的指令
`include "defines.v"

module inst_rom(
    input wire                      ce_i,
    input wire[`Inst_Addr_Bus]      addr_i,
    
    output reg[`Inst_Bus]           inst_o
);

    reg [`Inst_Bus] inst_mem[0 : 127];  // 128条指令的ROM，地址范围0~127，每条指令32位
    integer i;  // 用于初始化ROM的循环变量

    // 根据地址和使能信号输出指令
    always @ (*) begin
        if (ce_i == `Chip_DIS) begin
            inst_o = `Word_Zero;
        end else begin
            inst_o = inst_mem[addr_i[8 : 2]];
        end
    end

    //适用于仿真环境的ROM初始化，预装载一些指令
    initial begin
        for (i = 0; i < 128; i = i + 1) begin
            inst_mem[i] = `Word_Zero;
        end

	    inst_mem[0] = 32'h34011100;
        inst_mem[1] = 32'h34020020;
        inst_mem[2] = 32'h3403ff00;
        inst_mem[3] = 32'h3404ffff;
    end

	
endmodule