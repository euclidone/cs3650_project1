`timescale 1ps/1ps
`include "MIPS_Single_Cycle.v"

module tb_MIPS_Single_Cycle();

reg clk,rst_n;      // clock and reset
reg [31:0] cnt;     // 32 bit count (used as a variable to count up)

//dumping the results to MIPS_wave.vcd
initial
begin            
    $dumpfile("MIPS_wave.vcd");         // to generate a file called "MIPS_wave.vcd" to view the waves.
    $dumpvars(0, tb_MIPS_Single_Cycle); 
end

initial begin
    clk <= 1'b0;    // Nonblocking assignment of 1 bit 0s
    rst_n <= 1'b0;  // Nonblocking assignment of 1 bit 0s
    cnt <= 32'b0;   // Nonblocking assignment of 32 bit 0s

    #10             // Delay in 10ps timescale unit
    clk <= 1'b1;    // Nonblocking assignment of 1 bit of 1s

    #10             // Delay in 10ps timescale unit
    clk <= 1'b0;    // Nonblocking assignment of 1 bit of 0s
    rst_n <= 1'b1;  // Nonblocking assignment of 1 bit of 1s

    // continuous block begin
    forever begin
        #10 clk <= ~clk; //delay in 10ps assignment of negation clk to clk
    end

end
//executes when clk goes to 0 from 1
always @(negedge clk) begin
    cnt <= cnt + 1'b1;      // adds 1 bit of 1 to cnt
    if (cnt >= 17) begin    // if count is greater than or equal to 17 stop counting up.
        $stop;
    end
end

//instantation of MIPS_Single_Cycle
MIPS_Single_Cycle u_MIPS_Single_Cycle(
    .clk(clk),
    .rst_n(rst_n)
);

endmodule