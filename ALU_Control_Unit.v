module ALU_Control_Unit(
    // System Clock

    // User Interface
    input       [5:0]   Funct,      // input is 6 bits
    input       [1:0]   ALUOp,      // input is 2 bits
    output  reg [2:0]   ALUControl  // output is 3 bits
);

    always @(*) begin
        case (ALUOp)
            2'b00: ALUControl = 3'b010; //instruction: sw, ALU control input: add
            2'b10: begin //instruction: lw, ALU control input: add
                case (Funct)                        
                    //funct field ALU control input
                    6'b100000 : ALUControl = 3'b010; //add
                    6'b100010 : ALUControl = 3'b110; //subtract
                    6'b100100 : ALUControl = 3'b000; //AND
                    6'b100101 : ALUControl = 3'b001; //OR
                    6'b101010 : ALUControl = 3'b111; //set on less than
                endcase
            end
            2'b01: ALUControl = 3'b110; //instruction: beq, ALU control input: subtract
            default: ;
        endcase 
    end


endmodule