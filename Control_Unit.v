module Control_Unit(
    // System Clock
    input        clk,
    input        rst_n,

    // User Interface
    output  reg [1:0]    ALUOp,
    output  reg     MemWrite,RegWrite, // Will there be writing to memory/register
    output  reg     RegDst, // Destination register
    output  reg     MemtoReg, // Will data be passed from memory to register
    output  reg     ALUSrc,
    output  reg     Branch, // Is there branching involved 
    output  reg     Jump, // Is there jumping involved 
    input   [5:0]   Opcode // inputted Opcode to know what operation to conduct
);

always @(*) begin
    case (Opcode) // Switch statement to decide what values to output based on the instruction
        // R type no Immediate Instruction
        6'b000000 : begin
            RegWrite = 1'b1;
            RegDst   = 1'b1;
            ALUSrc   = 1'b0;
            Branch   = 1'b0;
            MemWrite = 1'b0;
            MemtoReg = 1'b0;
            ALUOp    = 2'b10;
            Jump     = 1'b0;
        end
        // beq Instruction
        6'b000100 : begin
            RegWrite = 1'b0;
            RegDst   = 1'b0;    // dont care
            ALUSrc   = 1'b0;
            Branch   = 1'b1;    
            MemWrite = 1'b0;
            MemtoReg = 1'b0;    // dont care
            ALUOp    = 2'b01;
            Jump     = 1'b0;
        end
        // sw Instruction
        6'b101011 : begin
            RegWrite = 1'b0;
            RegDst   = 1'b0;    // dont care
            ALUSrc   = 1'b1;
            Branch   = 1'b0;
            MemWrite = 1'b1;
            MemtoReg = 1'b1;    // dont care
            ALUOp    = 2'b00;
            Jump     = 1'b0;
        end
        // lw Instruction
        6'b100011 : begin
            RegWrite = 1'b1;
            RegDst   = 1'b0;
            ALUSrc   = 1'b1;
            Branch   = 1'b0;
            MemWrite = 1'b0;
            MemtoReg = 1'b1;
            ALUOp    = 2'b00;
            Jump     = 1'b0;
        end
        // addi Instruction
        6'b001000 : begin
            RegWrite = 1'b1;
            RegDst   = 1'b0;
            ALUSrc   = 1'b1;
            Branch   = 1'b0;
            MemWrite = 1'b0;
            MemtoReg = 1'b0;
            ALUOp    = 2'b00;
            Jump     = 1'b0;
        end
        // J type Instruction
        6'b000010 : begin
            RegWrite = 1'b0;
            RegDst   = 1'b0;
            ALUSrc   = 1'b0;
            Branch   = 1'b0;
            MemWrite = 1'b0;
            MemtoReg = 1'b0;
            ALUOp    = 2'b00;
            Jump     = 1'b1;
        end
        default: ;
    endcase
end

endmodule