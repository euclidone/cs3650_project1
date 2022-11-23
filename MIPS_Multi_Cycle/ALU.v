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
    reg [31:0]  SrcA,SrcB; // 32-bit values to calculate    

    
    assign Zero = (ALUResult) ? 1'b0 : 1'b1; //set on
    always @(*) begin
        SrcA = ALUSrcA ? A : PC; // Checking if SrcA is the same as SrcA in the ALU. If so, Set SrcA to address A. Else set it to the Program Counter(PC)
        case(ALUSrcB)
            2'b00: SrcB = B; // If the value of ALUSrcB is 00 then SrcB is equal to address B
            2'b01: SrcB = 32'd4; // If it is 01 then set it to decimal value 4 with a width of 32 bits
            2'b10: SrcB = SignImm; // If it is 10 then set it to the sign extended number
            2'b11: SrcB = SignImm << 2; // If it is 11 then set it to the twice left shifted sign extended number
        endcase
    end

    always @(*) begin
        case (ALUControl)
            3'b010 : begin // Add
                ALUResult = SrcA + SrcB;
            end 
            3'b110 : begin // Subtract
                ALUResult = SrcA - SrcB;
            end
            3'b000 : ALUResult = SrcA & SrcB; // AND
            3'b001 : ALUResult = SrcA | SrcB; // OR
            3'b111 : ALUResult = (SrcA < SrcB) ? 32'b1 : 32'b0; // Set on less than
            default: ;
        endcase
    end

    always @(posedge clk) begin
        ALUOut <= ALUResult; // Equates ALUOut to ALUResult
    end


endmodule