module ALU(
    // System Clock

    // User Interface
    input       [31:0]  SrcA,       // 32-bit value to calculate
    input       [31:0]  SrcB,       // 32-bit value to calculate
    input       [2:0]   ALUControl, // 3-bit that dictates the ALU control unit
    output  reg [31:0]  ALUResult,  // 32-bit result of the dictated operation
    output              Zero 
);

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

    assign Zero = (ALUResult) ? 1'b0 : 1'b1; // Set on

endmodule