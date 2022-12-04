/*

	File name    : ALU_Control_Unit
	LastEditors  : H
	LastEditTime : 2021-11-04 21:33:54
	Last Version : 1.0
	Description  : Control the ALU Unit to run specific operation. Output the Signal Alucontrol
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-11-03 21:01:39
	FilePath     : \MIPS_Pipeline\ALU_Control_Unit.v
	Copyright 2021 H, All Rights Reserved. 

*/

module ALU_Control_Unit(
    // System Clock

    // User Interface
    input       [5:0]   Funct,      // input is 6 bits
    input       [1:0]   ALUOp,      // input is 2 bits
    output  reg [2:0]   ALUControl  // output is 3 bits
);
/*******************************************************************************
 *                                 Main Code
*******************************************************************************/

    // Switch statement based off of the op code to determine what operation to perform and outputs it through the variable ALUControl
    always @(*) begin
        case (ALUOp)
            2'b00: ALUControl = 3'b010; // If the value of ALUOp is 0 in binary then set ALUControl to 2 in binary which equals subtraction
            2'b10: begin                // If it is 2 in binary then go into next switch statement based on passed function Func and determine the value
                case (Funct)
                    6'b100000 : ALUControl = 3'b010; // Subtract
                    6'b100010 : ALUControl = 3'b110; // OR
                    6'b100100 : ALUControl = 3'b000; // Addition
                    6'b100101 : ALUControl = 3'b001; // Increment
                    6'b101010 : ALUControl = 3'b111; // AND
                endcase
            end
            2'b01: ALUControl = 3'b110; // If the value is 1, then set ALUControl to OR
            default: ;                  // Default value does nothing 
        endcase
    end


endmodule