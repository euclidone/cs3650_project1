/*

	File name    : Data_Memory
	LastEditors  : H
	LastEditTime : 2021-10-28 17:09:32
	Last Version : 1.0
	Description  : 
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-10-28 17:09:31
	FilePath     : \MIPS_Single\Data_Memory.v
	Copyright 2021 H, All Rights Reserved. 

*/
module Data_Memory(
    // System Clock
    input        clk,               // clock
    input        rst_n,             // reset

    // User Interface
    input           [31:0]  A,      // input is 32 bits
    input           [31:0]  WD,     // input is 32 bits
    input                   WE,

    output   reg    [31:0]  RD      // output is 32 bits
);
    integer fd;
    reg [31:0]  DATA_MEM[84:0];     // register is 32 bits, DATA MEMORY is 85 bits
/*******************************************************************************
 *                                 Main Code
*******************************************************************************/

    initial begin
        fd = $fopen("./MEM_Data.txt", "w"); // open MEM_Data.txt then write to it.
        #500                                // delay by 500 pico-seconds
        $fclose(fd);                        // close the opened file.
    end

    always @(*) begin
        RD = DATA_MEM[A];
    end

    always @(posedge clk) begin
        if (WE) begin
            DATA_MEM[A] <= WD; //combining two to be outputted together
            $fdisplay(fd,"The Write Address A is %h", A);
            $fdisplay(fd,"DATA_MEM[A] is %h", WD);
        end
    end

endmodule