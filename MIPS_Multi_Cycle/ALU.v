module ALU(
    // System Clock
    input               clk,
    // User Interface
    input               ALUSrcA, // ALU's current address A
    input       [1:0]   ALUSrcB, // ALU's current address B
    input       [31:0]  A, // Input address A
    input       [31:0]  B, // Input address B
    input       [31:0]  PC, // Program counter
    input       [31:0]  SignImm, // Sign-extended number

    // input       [31:0]  SrcA,
    // input       [31:0]  SrcB,

    input       [2:0]   ALUControl, //3-bit that dictates the ALU control unit
    output  reg [31:0]  ALUOut, // 32-bit output that is equated to ALUResult at the end
    output  reg [31:0]  ALUResult, //32-bit result of the dictated operation
    output              Zero
);
    reg [31:0]  SrcA,SrcB;

/*******************************************************************************
 *                                 Main Code
*******************************************************************************/
    
    assign Zero = (ALUResult) ? 1'b0 : 1'b1; //set on
    always @(*) begin
        SrcA = ALUSrcA ? A : PC;
        case(ALUSrcB)
            2'b00: SrcB = B;
            2'b01: SrcB = 32'd4;
            2'b10: SrcB = SignImm;
            2'b11: SrcB = SignImm << 2;
        endcase
    end

    always @(*) begin
        case (ALUControl)
            3'b010 : begin
                ALUResult = SrcA + SrcB;
            end 
            3'b110 : begin
                ALUResult = SrcA - SrcB;
            end
            3'b000 : ALUResult = SrcA & SrcB;
            3'b001 : ALUResult = SrcA | SrcB;
            3'b111 : ALUResult = (SrcA < SrcB) ? 32'b1 : 32'b0;
            default: ;
        endcase
    end

    always @(posedge clk) begin
        ALUOut <= ALUResult;
    end


endmodule