/*

	File name    : IF_ID_Register
	LastEditors  : H
	LastEditTime : 2021-11-03 21:02:04
	Last Version : 1.0
	Description  : Pipeline Stage Register : IF/ID
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-11-03 21:02:03
	FilePath     : \MIPS_Pipeline\IF_ID_Register.v
	Copyright 2021 H, All Rights Reserved. 

*/
module IF_ID_Register(
    // System Clock
    input        clk,               // clock
    input        rst_n,             // reset

    input               StallD,
    input               PCSrcD,
    input               JumpD,

    // User Interface
    input       [31:0]  PCPlus4F,   // input is 32 bits
    input       [31:0]  Instr,      // input is 32 bits

    output  reg [31:0]  PCPlus4D,   // output is 32 bits
    output  reg [31:0]  InstrD      // output is 32 bits
);
/*******************************************************************************
 *                                 Main Code
*******************************************************************************/
    //seperating the fetch and decode stages
    always @(posedge clk ) begin
        if (~rst_n) begin 
            PCPlus4D <= 32'b0; //Assigning 32 bits of 0s
            InstrD <= 32'b0; //Assigning 32 bits of 0s
        end
        else if (PCSrcD || JumpD) begin
            InstrD <= 32'b0; //Assigning 32 bits of 0s
            PCPlus4D <= 32'b0; //Assigning 32 bits of 0s
        end
        else if (StallD) begin //if StallID set
            PCPlus4D <= PCPlus4D;
            InstrD   <= InstrD;
        end
        else begin
            // total 64bits
            PCPlus4D <= PCPlus4F;//combining two to be outputted together
            InstrD   <= Instr;//combining two to be outputted together
        end
    end

endmodule