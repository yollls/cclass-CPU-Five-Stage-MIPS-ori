//  顶层模块
//  负责连接CPU和指令ROM，并提供时钟和复位信号
`include "defines.v"

module top_file(
    input wire          clk,
    input wire          rst
    );


    wire[`Inst_Addr_Bus] inst_addr;
    wire[`Inst_Bus] inst;
    wire rom_ce;
  
	cpu CPU (
        .clk(clk),
        .rst(rst),

        .rom_addr_o(inst_addr),
        .rom_data_i(inst),
        .rom_ce_o(rom_ce)
    );

    // ROM   
    inst_rom inst_rom (
        .ce_i(rom_ce),
        .addr_i(inst_addr),
        .inst_o(inst)
    );

endmodule