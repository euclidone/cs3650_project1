module PC_Counter(
    // System Clock
    input                       clk,
    input                       rst_n,

    // User Interface
    input                       PCEn, // Program Counter encoded or not
    input                       IorD,   // Instruction or Data
    input               [1:0]   PCSrc, // Source of Program Counter
    input               [25:0]  Jump_low_26Bit, // Used for jumping
    input               [31:0]  ALUOut, // ALU Output
    input               [31:0]  ALUResult, // ALU Result value after calculation
    output              [31:0]  Adr, // Output Address
    output  reg         [31:0]  PC // Output Program Counter Value
);
    reg                 [31:0]  PC_Next; // Next Program Counter value

/*******************************************************************************
 *                                 Main Code
*******************************************************************************/

    assign Adr = IorD ? ALUOut : PC; // If it is equal to IorD set it to ALUOut otherwise set it to program counter
    // MIPS Multi Cycle: Use ALU to Calculate the PC + 4
    always @(*) begin
        case(PCSrc) // Switch statement based off of PCSrc
            2'b00: PC_Next = ALUResult; // If it is 00, next program counter value is equal to ALUResult
            2'b01: PC_Next = ALUOut; // If it is 01, next program counter value is equal to ALUOut  
            2'b10: PC_Next = {{PC[31:28]}, {Jump_low_26Bit}, 2'b00}; // If it is 10, then set it to the last 4 bits of current program
            // counter value, the low 26 bits for jump, and a 00 binary value
        endcase
    end

    always @(posedge clk) begin
        if(~rst_n)begin
            // Resetting Program Counter to a 32 bit length binary value of all 0s
            PC <= 32'b0;
        end
        else if (PCEn) begin
            // Program Counter is instead set to the next Program Counter value
            PC <= PC_Next;
        end
    end

endmodule