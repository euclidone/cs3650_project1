`include "PC_Counter.v"
`include "Control_Unit.v"
`include "Reg_File.v"
`include "Imm_Sign_Extend.v"
`include "Instr_Data_Memory.v"
`include "ALU_Control_Unit.v"
`include "ALU.v"

module MIPS_Multi_Cycle(
    // System Clock
    input               clk,
    input               rst_n

    // User Interface
    
);
    wire [31:0]         PC; // 32 bits program counter
    wire [31:0]         ALUResult; // 32 bit for the resulting value from ALU
    wire [31:0]         SignImm; // 32 bits for sign-extended number
    wire [31:0]         ALUOut; // 32 bit output for ALU value
    wire [31:0]         Instr; // Instruction wire to handle operations involving instructions
    wire [31:0]         Data; // Data wire to handle operations involving data
    wire [31:0]         A,B; // Addresses A and B
    wire [31:0]         Adr; // Address wire
    wire [31:0]         WriteRegData; // Data to be written in register
    
    wire [2:0]          ALUControl; // ALU control bits to decide operation
    wire [1:0]          ALUOp; // ALU operation value
    wire [1:0]          PCSrc; // Program Count source
    wire [4:0]          WriteReg; // Register we are writing to. 5 bits because 2^5 is 32
    wire [1:0]          ALUSrcB; // ALU'S address B
    wire                ALUSrcA; // ALU'S address A

    wire                MemWrite, RegWrite, IorD; // Write to memory or not, Write to register or not, Instruction or Data
    wire                RegDst, ALUSrc, MemtoReg; // Register destination, ALU Value, Will data be passed from memory to register signal
    wire                Branch, Zero; // Branch or not, value is zero or not
    wire                PCEn, PCWrite, IRWrite; // Encode program counter or not, write to program counter or not, write Instruction or not
    
/*******************************************************************************
 *                                 Main Code
*******************************************************************************/

    assign PCEn         = (Branch & Zero) | PCWrite; // Checking if we encode Program Counter or not

    assign WriteReg     = RegDst ? Instr[15:11] : Instr[20:16]; // Set on. If the write register is equal to destination 
    // register then set it to bits 11-15. Otherwise set it to 16-20

    assign WriteRegData = MemtoReg ? Data : ALUOut; // Deciding whether WriteRegData should be equal to Data that is being passed in
    // or ALUOut result

    // Instantiates PC_Counter
    PC_Counter u_PC_Counter(
        .clk            (clk),
        .rst_n          (rst_n),
        .PCSrc          (PCSrc),
        .PCEn           (PCEn),
        .IorD           (IorD),
        .ALUOut         (ALUOut),
        .ALUResult      (ALUResult),
        .Jump_low_26Bit (Instr[25:0]),
        .Adr            (Adr),
        .PC             (PC)
    );

    // Instantiates Instr_Data_Memory
    Instr_Data_Memory u_Instr_Data_Memory(
        .clk            (clk),
        .A              (Adr),
        .WD             (B),
        .IRWrite        (IRWrite),
        .MemWrite       (MemWrite),
        .Instr          (Instr),
        .Data           (Data)
    );
    
    // Instantiates Control_Unit
    Control_Unit u_Control_Unit(
        .clk            (clk),
        .rst_n          (rst_n),
        .Opcode         (Instr[31:26]),
        .ALUOp          (ALUOp),
        .MemtoReg       (MemtoReg),
        .RegDst         (RegDst),
        .IorD           (IorD),
        .PCSrc          (PCSrc),
        .ALUSrcA        (ALUSrcA),
        .ALUSrcB        (ALUSrcB),
        .IRWrite        (IRWrite),
        .MemWrite       (MemWrite),
        .PCWrite        (PCWrite),
        .Branch         (Branch),
        .RegWrite       (RegWrite)
    );

    // Instantiates Reg_File
    Reg_File u_Reg_File(
        .clk            (clk),
        .A1             (Instr[25:21]),
        .A2             (Instr[20:16]),
        .A3             (WriteReg),
        .A              (A),
        .B              (B),
        .RegWrite       (RegWrite),
        .WD3            (WriteRegData)
    );

    // Instantiates Imm_Sign_Extend
    Imm_Sign_Extend u_Imm_Sign_Extend(
        .Immediate      (Instr[15:0]),
        .SignImm        (SignImm)
    );

    // Instantiates ALU_Control_Unit
    ALU_Control_Unit u_ALU_Control_Unit(
        .Funct          (Instr[5:0]),
        .ALUOp          (ALUOp),
        .ALUControl     (ALUControl)
    );

    // Instantiates ALU
    ALU u_ALU(
        .clk            (clk),
        .ALUSrcA        (ALUSrcA),
        .ALUSrcB        (ALUSrcB),
        .ALUControl     (ALUControl),
        .A              (A),
        .B              (B),
        .PC             (PC),
        .SignImm        (SignImm),
        .ALUOut         (ALUOut),
        .ALUResult      (ALUResult),
        .Zero           (Zero)
    );

endmodule