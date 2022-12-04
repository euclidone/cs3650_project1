/*

	File name    : Reg_File
	LastEditors  : H
	LastEditTime : 2021-11-04 21:43:02
	Last Version : 1.0
	Description  : 
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-11-03 21:01:39
	FilePath     : \MIPS_Pipeline\Reg_File.v
	Copyright 2021 H, All Rights Reserved. 

*/

module Reg_File (
    input               clk, //clock
    input               rst_n, //reset
    input       [4:0]   A1,         // Address 1
    input       [4:0]   A2,         // Address 2
    input       [4:0]   A3,         // Address 3

    input               RegWrite, //register written to
    input       [31:0]  WD3,        // write date
    output      [31:0]  RD2,        // read data 2
    output      [31:0]  RD1         // read data 1

);
    // lw : load word instr [op(6bit) rs(5bit) rd(5bit) imm(16bit)]

    reg [31:0]  ROM [31:0]; // 32 ROMs of 32 bits each = 1024
    initial begin
        ROM[0] <= 32'b0; //Assignment 32 bits to ROMS 1 - 16
        ROM[1] <= 32'b0;
        ROM[2] <= 32'b0;
        ROM[3] <= 32'b0;
        ROM[4] <= 32'b0;
        ROM[5] <= 32'b0;
        ROM[6] <= 32'b0;
        ROM[7] <= 32'b0;
        ROM[8] <= 32'b0;
        ROM[9] <= 32'b0;
        ROM[10] <= 32'b0;
        ROM[11] <= 32'b0;
        ROM[12] <= 32'b0;
        ROM[13] <= 32'b0;
        ROM[14] <= 32'b0;
        ROM[15] <= 32'b0;
    end


    assign RD1 = ROM[A1];//Assigning the ROM at index A1 to RD1
    assign RD2 = ROM[A2];//Assigning the ROM at index A@ to RD2
    // RegWrite is set to 1 when lw Instr is executed
    always @(negedge clk) begin //if clock has a negatuvwe edge
        if (RegWrite) begin
            // load word
            ROM[A3] <= WD3;//Assigning WD# to the ROM at index A3
        end
    end
endmodule