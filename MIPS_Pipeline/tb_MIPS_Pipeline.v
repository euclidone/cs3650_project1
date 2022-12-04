/*

	File name    : tb_MIPS_Pipeline
	LastEditors  : H
	LastEditTime : 2021-11-04 21:43:18
	Last Version : 1.0
	Description  : testbench of MIPS_Pipeline
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-11-04 21:33:08
	FilePath     : \MIPS_Pipeline\tb_MIPS_Pipeline.v
	Copyright 2021 H, All Rights Reserved. 

*/

`timescale 1ps/1ps
module tb_MIPS_Pipeline();

reg clk,rst_n; //clock and active signal(active low reset)
reg [31:0] cnt; // register is 32 bits

initial
begin            
    $dumpfile("MIPS_wave.vcd");        // generate a file MIPS_wave.vcd
    $dumpvars(0, tb_MIPS_Pipeline);    //tbģ������
end

initial begin
    clk <= 1'b0; //non-blocking assignent of 0 to clock
    rst_n <= 1'b0; //non-blocking assignment of 0 to rst_n
    cnt <= 32'b0; //non-blocking assignment of 32 0s to count

    #10          //wait 10 timescales
    clk <= 1'b1; //non-blocking assignment of 1 to clock

    #10          //wait 10 timescales 
    clk <= 1'b0; //nonb-locking assignment of 0 to clock
    rst_n <= 1'b1; //non-blocking assingment of 1 to rst_n 

    forever begin
        #10 clk <= ~clk; //wait 10 and assign negationc clock to clock
    end

end

always @(negedge clk) begin //begins if clock has a negative edge
    cnt <= cnt + 1'b1;              // count =+ 1
    if (cnt >= 25) begin            // if the count is greater or equal to 25 then stop
        $stop;
    end
end

//instantiation of MIPS_Pipeline
//connecting the clock and active
//signal to the tb module 
MIPS_Pipeline u_MIPS_Pipeline(
    .clk(clk),
    .rst_n(rst_n)
);

endmodule