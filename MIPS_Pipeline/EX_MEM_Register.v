/*

	File name    : EX_MEM_Register
	LastEditors  : H
	LastEditTime : 2021-11-03 21:09:08
	Last Version : 1.0
	Description  : Pipeline Stage Register : EX/MEM
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-11-03 21:09:07
	FilePath     : \MIPS_Pipeline\EX_MEM_Register.v
	Copyright 2021 H, All Rights Reserved. 

*/
module EX_MEM_Register(
    // System Clock
    input        clk,                   // clock
    input        rst_n,                 // reset

    // User Interface
    input       [31:0]  ALUOut,         // input is 32 bits
    input       [31:0]  WriteDataE,     // input is 32 bits
    input       [4:0]   WriteRegE,      // input is 5 bits    
    input               Zero,

    output  reg [31:0]  ALUOutM,        // output is 32 bits
    output  reg [31:0]  WriteDataM,     // output is 32 bits
    output  reg [4:0]   WriteRegM,      // output is 5 bits
    output  reg         ZeroM,

    // Control Unit Input
    input               RegWriteE,
    input               MemtoRegE,
    input               MemWriteE,

    // WB Signal
    output  reg         RegWriteM,
    output  reg         MemtoRegM,

    // MEM Signal
    output  reg         MemWriteM
);
/*******************************************************************************
 *                                 Main Code
*******************************************************************************/

    always @(posedge clk or negedge rst_n ) begin
        if(!rst_n)begin
            ZeroM       <= 1'b0;
            RegWriteM   <= 1'b0;
            MemtoRegM   <= 1'b0;
            MemWriteM   <= 1'b0;
        end
        else begin
            // 97 bits 
            ALUOutM     <= ALUOut;
            WriteDataM  <= WriteDataE;
            WriteRegM   <= WriteRegE;
            ZeroM       <= Zero;

            // Control Unit Signal
            RegWriteM   <= RegWriteE;
            MemtoRegM   <= MemtoRegE;
            MemWriteM   <= MemWriteE;
        end
    end

endmodule
