/*

	File name    : ID_EX_Register
	LastEditors  : H
	LastEditTime : 2021-11-03 21:05:45
	Last Version : 1.0
	Description  : Pipeline Stage Register : ID/EX
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-11-03 21:05:43
	FilePath     : \MIPS_Pipeline\ID_EX_Register.v
	Copyright 2021 H, All Rights Reserved. 

*/
module ID_EX_Register(
    // System Clock
    input        clk,               // clock
    input        rst_n,             // reset

    // User Interface
    input       [31:0]  RD1,        // input is 32 bits
    input       [31:0]  RD2,        // input is 32 bits
    input       [4:0]   Rt,         // input is 5 bits
    input       [4:0]   Rs,         // input is 5 bits
    input       [4:0]   Rd,         // input is 5 bits
    input       [31:0]  SignImm,    // input is 32 bits
    input       [31:0]  PCPlus4D,   // input is 32 bits

    output  reg [31:0]  RD1E,       // output is 32 bits
    output  reg [31:0]  RD2E,       // output is 32 bits
    output  reg [4:0]   RtE,        // output is 5 bits
    output  reg [4:0]   RsE,        // output is 5 bits
    output  reg [4:0]   RdE,        // output is 5 bits
    output  reg [31:0]  SignImmE,   // output is 32 bits
    output  reg [31:0]  PCPlus4E,   // output is 32 bits

    // Control Unit Input
    input               RegWriteD,
    input               MemtoRegD,
    input               MemWriteD,
    input               RegDstD,
    input               ALUSrcD,

    input               FlushE,
    input       [2:0]   ALUControlD,    // input is 3 bits

    // WB 
    output  reg         RegWriteE,
    output  reg         MemtoRegE,

    // MEM
    output  reg         MemWriteE,

    // EX
    output  reg         RegDstE,
    output  reg         ALUSrcE,
    output  reg [2:0]   ALUControlE     // output is 3 bits
);
/*******************************************************************************
 *                                 Main Code
*******************************************************************************/

    //seperating the decode and execute stages
    always @(posedge clk or negedge rst_n ) begin
        if(!rst_n)begin
            RegWriteE   <=  1'b0;
            MemtoRegE   <=  1'b0;
            MemWriteE   <=  1'b0;
            RegDstE     <=  1'b0;
            ALUSrcE     <=  1'b0;
            ALUControlE <= 3'b000;
        end
        else if (FlushE) begin
            RegWriteE   <=  1'b0;
            MemtoRegE   <=  1'b0;
        end
        else begin
            // total 128bits
            RD1E        <= RD1;//combining two to be outputted together
            RD2E        <= RD2;//combining two to be outputted together
            RtE         <= Rt;//combining two to be outputted together
            RsE         <= Rs;//combining two to be outputted together
            RdE         <= Rd;//combining two to be outputted together
            SignImmE    <= SignImm;//combining two to be outputted together
            PCPlus4E    <= PCPlus4D;//combining two to be outputted together

            // Control Unit Signal
            RegWriteE   <=  RegWriteD;//combining two to be outputted together
            MemtoRegE   <=  MemtoRegD;//combining two to be outputted together
            MemWriteE   <=  MemWriteD;//combining two to be outputted together
            RegDstE     <=  RegDstD;//combining two to be outputted together
            ALUSrcE     <=  ALUSrcD;//combining two to be outputted together
            ALUControlE <=  ALUControlD;//combining two to be outputted together
        end
    end

endmodule
