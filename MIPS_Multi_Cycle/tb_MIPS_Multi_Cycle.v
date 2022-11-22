`timescale 1ps/1ps
module tb_MIPS_Multi_Cycle();

reg clk,rst_n;
reg [31:0] cnt;

/*******************************************************************************
 *                                 Main Code
*******************************************************************************/

initial
begin            
    $dumpfile("MIPS_wave.vcd");        
    $dumpvars(0, tb_MIPS_Multi_Cycle);    
end

initial begin
    clk     <= 1'b0;
    rst_n   <= 1'b0;
    cnt     <= 32'b0;

    #10
    clk     <= 1'b1;

    #10
    clk     <= 1'b0;
    rst_n   <= 1'b1;

    forever begin
        #10 clk <= ~clk;
    end
end

always @(negedge clk) begin
    cnt <= cnt + 1'b1;
    if (cnt >= 72) begin
        $stop;
    end
end

MIPS_Multi_Cycle u_MIPS_Multi_Cycle(
    .clk(clk),
    .rst_n(rst_n)
);

endmodule