`timescale 1ps/1ps
module tb_MIPS_Multi_Cycle();

reg clk,rst_n; // Clock and reset
reg [31:0] cnt; // 32 bit count (used as a variable to count up)

/*******************************************************************************
 *                                 Main Code
*******************************************************************************/

// dumping the results to MIPS_wave.vcd

initial
begin            
    $dumpfile("MIPS_wave.vcd"); // to generate a file called "MIPS_wave.vcd to view the waves"
    $dumpvars(0, tb_MIPS_Multi_Cycle);    
end

initial begin
    clk     <= 1'b0; // Nonblocking assignment of 1 bit 0s to clock
    rst_n   <= 1'b0; // Nonblocking assignment of 1 bit 0s to reset
    cnt     <= 32'b0; // Nonblocking assignment of 32 bit 0s to count

    #10 // Delay in 10ps timescale unit
    clk     <= 1'b1; // Nonblocking assignment of 1 bit of 1s to clock

    #10 // Delay in 10ps timescale unit
    clk     <= 1'b0; // Nonblocking assignment of 1 bit of 0s to clock
    rst_n   <= 1'b1; // Nonblocking assignment of 1 bit of 1s to reset

// Continuous block begin
    forever begin
        #10 clk <= ~clk; // delay in 10ps assignment of negation clock to clock
    end
end

// executes when clk goes from 0 to 1
always @(negedge clk) begin
    cnt <= cnt + 1'b1; //  adds 1 bit of 1 to count
    if (cnt >= 72) begin // when count reaches or surpasses 72 stop incrementing the counter
        $stop;
    end
end

// Instantiation of MIPS_Multi_Cycle
MIPS_Multi_Cycle u_MIPS_Multi_Cycle(
    .clk(clk),
    .rst_n(rst_n)
);

endmodule