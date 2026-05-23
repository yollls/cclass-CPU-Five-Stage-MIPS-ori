//  ORI指令测试模块
//  负责测试ORI指令的正确性，包括指令的译码、执行和结果的写回
`include "defines.v"

module ORItest();

  reg   clk;
  reg   rst;
  
  top_file uut (
		.clk(clk),
		.rst(rst)
	);
	
	initial clk = 1'b0;
	always #5 clk = ~clk;

	always @(posedge clk) begin
		$display("[%0t] rst=%b ce=%b pc=%h inst=%h", $time, rst, uut.rom_ce, uut.inst_addr, uut.inst);
	end

  // 复位信号

  	initial begin
    	rst = 1'b1;      // 开始时复位
    	#195 rst = 1'b0;    // 195ns后释放复位
	    #120;
	    $display("REG_DUMP: r1=%h r2=%h r3=%h r4=%h", uut.CPU.regfile.regs[1], uut.CPU.regfile.regs[2], uut.CPU.regfile.regs[3], uut.CPU.regfile.regs[4]);
    	#1000 $finish;     // 仿真1000ns后结束

  end

endmodule