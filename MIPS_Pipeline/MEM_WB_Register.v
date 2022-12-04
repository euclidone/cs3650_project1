/*

	File name    : MEM_WB_Register
	LastEditors  : H
	LastEditTime : 2021-11-03 21:11:19
	Last Version : 1.0
	Description  : Pipeline Stage Register : MEM/WB
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-11-03 21:11:18
	FilePath     : \MIPS_Pipeline\MEM_WB_Register.v
	Copyright 2021 H, All Rights Reserved. 

*/
module MEM_WB_Register(
    // System Clock
    input        clk,               // clock
    input        rst_n,             // result

    // User Interface
    input       [31:0]  ReadDataM,  // input is 32 bits
    input       [31:0]  ALUOutM,    // input is 32 bits
    input       [4:0]   WriteRegM,  // input is 5 bits

    output  reg [31:0]  ReadDataW,  // output is 32 bits
    output  reg [31:0]  ALUOutW,    // output is 32 bits
    output  reg [4:0]   WriteRegW,  // output is 5 bits

    // Control Signal 
    input               RegWriteM,
    input               MemtoRegM,

    // WB
    output  reg         RegWriteW,
    output  reg         MemtoRegW
);
/*******************************************************************************
 *                                 Main Code
*******************************************************************************/
    //Pipe m to w
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            //resets all signals
            RegWriteW <= 1'b0;
            MemtoRegW <= 1'b0;
        end
        else begin
            // total 64bits
            //memory stage values
            ReadDataW <= ReadDataM; //combining two to be outputted together
            ALUOutW   <= ALUOutM; //combining two to be outputted together
            WriteRegW <= WriteRegM; //combining two to be outputted together

            // Control Unit signale
            RegWriteW <= RegWriteM; //combining two to be outputted together
            MemtoRegW <= MemtoRegM; //combining two to be outputted together
        end
    end

endmodule