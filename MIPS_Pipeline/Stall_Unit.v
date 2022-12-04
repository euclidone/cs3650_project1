/*

	File name    : Stall_Unit
	LastEditors  : H
	LastEditTime : 2021-11-04 03:18:01
	Last Version : 1.0
	Description  : Handle Hazard Unit (Using Block/Bubble)
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-11-04 03:18:00
	FilePath     : \MIPS_Pipeline\Stall_Unit.v
	Copyright 2021 H, All Rights Reserved. 

*/
module Stall_Unit(
    // System Clock
    input        clk,           // clock
    input        rst_n,         // reset

    // User Interface
    input   [4:0]   RsD,        // first source register from decode
    input   [4:0]   RtD,        // second source register from decode
    input   [4:0]   RtE,        // second source register from execute
    input   [4:0]   WriteRegE,  // register written to determined by exec stage
    input   [4:0]   WriteRegM,  // register written to determined by mem stage
    input           RegWriteE,  // register written to determined by exec stage
    input           MemtoRegE, //if data is written to from mem to exec by exec stage
    input           MemtoRegM, //if data is written to from mem to exec by mem stage
    input           BranchD, //if a branch instr, is executing
    output  reg     FlushE, //flag is set when exec stage needs to be flushed
    output  reg     StallD, //flag is set when decode needs to stall
    output  reg     StallF //flag is set when fetch needs to stall
);                              
                             //stall while we wait for LW'w WB stage
    wire lwstall,branchstall;//branch stall when a branch is taken
/*******************************************************************************
 *                                 Main Code
*******************************************************************************/

    //set if branching and writing to a source reg
    assign branchstall = (BranchD && RegWriteE && ((WriteRegE == RsD) || (WriteRegE == RtD))) ||
                            (BranchD && MemtoRegM && ((WriteRegM == RsD) || (WriteRegM == RtD)));
    //set whe writing from mem to reg
    assign lwstall = ((RsD == RtE) || (RtD == RtE)) && MemtoRegE;
    always @(*) begin
        if (~rst_n) begin
            FlushE = 1'b0;     // ID/EX: Only need to Set MemWrite and RegWrite 0
            StallD = 1'b0;     // IF/ID: keep last state data
            StallF = 1'b0;
        end
        else if (lwstall || branchstall ) begin //if lwstall or branchstall is set
            FlushE = 1'b1;     // ID/EX: Only need to Set MemWrite and RegWrite 0
            StallD = 1'b1;     // IF/ID: keep last state data
            StallF = 1'b1;     // PC:    keep last state data
        end 
        else begin // all else set to 0 for output
            FlushE = 1'b0;     
            StallD = 1'b0;     
            StallF = 1'b0;
        end
    end
endmodule