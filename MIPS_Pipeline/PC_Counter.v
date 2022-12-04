/*

	File name    : PC_Counter
	LastEditors  : H
	LastEditTime : 2021-11-04 21:42:50
	Last Version : 1.0
	Description  : Programm Instrcutions Counter
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-11-03 21:01:39
	FilePath     : \MIPS_Pipeline\PC_Counter.v
	Copyright 2021 H, All Rights Reserved. 

*/
module PC_Counter(
    // System Clock
    input        clk,                           // clock
    input        rst_n,                         // reset

    // User Interface
    input                   PCSrcD,             
    input                   StallF, //flag is set when fetch needs to stall
    input           [31:0]  PCBranchD,          // input is 32 bits
    input                   JumpD,
    input           [25:0]  InstrD_Low25Bit,    // input is 26 bits
    output          [31:0]  PCPlus4F,           // output is 32 bits
    output   reg    [31:0]  PC                  // output is 32 bits
);

    wire    [31:0] PC_Next,PC_Next_or_Jump,PC_Jump; // wire is 32 bits
    wire    [31:0] PCPlus4;                         // wire is 32 bits
/*******************************************************************************
 *                                 Main Code
*******************************************************************************/
    
    assign  PC_Next = PCSrcD ? PCBranchD : PCPlus4F; //Getting the next PC value
    assign  PC_Jump = {{PCPlus4F[31:28]},{InstrD_Low25Bit},{2'b00}};    //value for jumping
    assign  PCPlus4 = PC + 32'd4;                                       // PC + 4
    assign  PCPlus4F = PCPlus4;
    assign  PC_Next_or_Jump = JumpD ? PC_Jump : PC_Next; //Checking if next or jump


    always @(posedge clk) begin //execute on positive edge
        if(~rst_n)begin //execute if reset is negated
            PC <= 32'b0; //assign PC a 32 bit of 0s 
        end
        else if (StallF) begin //if fals is set
            PC <= PC; //assign PC to itself
        end
        else 
            PC <= PC_Next_or_Jump; // else assign PC to jump or next
    end

endmodule