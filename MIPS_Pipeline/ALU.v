/*

	File name    : ALU
	LastEditors  : H
	LastEditTime : 2021-10-28 16:44:49
	Last Version : 1.0
	Description  : ALU Unit
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-10-28 16:44:48
	FilePath     : \MIPS_Single\ALU.v
	Copyright 2021 H, All Rights Reserved. 

*/
module ALU(
    // System Clock
    input               rst_n,          // reset
    
    // User Interface
    input       [31:0]  SignImm,        // input is 32 bits
    input       [2:0]   ALUControl,     // input is 3 bits
    input               ALUSrc,         
    input       [1:0]   ForwardAE,      // input is 2 bits
    input       [1:0]   ForwardBE,      // input is 2 bits
    input       [31:0]  ResultW,        // input is 32 bits
    input       [31:0]  ALUOutM,        // input is 32 bits
    input       [31:0]  RD1E,           // input is 32 bits
    input       [31:0]  RD2E,           // input is 32 bits

    output  reg [31:0]  SrcB_Forward,   // output is 32 bits
    output  reg [31:0]  ALUOut,         // output is 32 bits
    output              Zero
);
    wire    [31:0] SrcB;            // wire is 32 bits
    reg     [31:0] SrcA;            // register is 32 bits
/*******************************************************************************
 *                                 Main Code
*******************************************************************************/

    assign  SrcB = ALUSrc ? SignImm : SrcB_Forward;//SrcB will be SignImm or SrcB_Forward

    always @(*) begin
        if (~rst_n) begin
            SrcA <= 32'b0;
            SrcB_Forward <= 32'b0;
        end
        else begin
            case(ForwardAE) // if ForwardAE is set then SRC will be the follwoing
                2'b00: SrcA = RD1E; 
                2'b01: SrcA = ResultW;
                2'b10: SrcA = ALUOutM;
            endcase 
            case (ForwardBE) // if ForwardBE is set then SRC will be the following
                2'b00: SrcB_Forward = RD2E;
                2'b01: SrcB_Forward = ResultW;
                2'b10: SrcB_Forward = ALUOutM;
            endcase
        end
    end

    always @(*) begin
        case (ALUControl) //Case depends on the ALUControl, wll execute various arithmetic and logic statments
            3'b010 : begin
                ALUOut = SrcA + SrcB; //add
            end 
            3'b110 : begin
                ALUOut = SrcA - SrcB; //sub
            end
            3'b000 : ALUOut = SrcA & SrcB;                      // AND
            3'b001 : ALUOut = SrcA | SrcB;                      // OR
            3'b111 : ALUOut = (SrcA < SrcB) ? 32'b1 : 32'b0;    // Set less than
            default: ;
        endcase
    end

    assign Zero = (ALUOut) ? 1'b0 : 1'b1;// will be 1 or 0

endmodule