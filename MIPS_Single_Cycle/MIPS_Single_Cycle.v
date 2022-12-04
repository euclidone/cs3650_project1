`timescale 1ps/1ps
`include "PC_Counter.v"
`include "Instr_Memory.v"
`include "Control_Unit.v"
`include "Reg_File.v"
`include "Imm_Sign_Extend.v"
`include "Data_Memory.v"
`include "ALU_Control_Unit.v"
`include "ALU.v"


module MIPS_Single_Cycle( // Instantiating an instance of a single cycle MIPS implementation 
    // System Clock
    input        clk,   // clock
    input        rst_n  // reset

    // User Interface
    
);
    wire [31:0]     PC;                 // 32 bits Program counter
    wire [31:0]     Instr,ALUResult;    // 32 bits 
    wire [31:0]     ReadData,WriteData; // 32 bits
    wire [31:0]     SrcA,SrcB;          // 32 bits
    wire            MemWrite,RegWrite;  

    wire            RegDst,ALUSrc,MemtoReg;

    wire [4:0]      WriteReg;           // 5 bits 
    wire [31:0]     SignImm,RD2;        // 32 bits
    wire [31:0]     WD3;                // 32 bits

    wire            PCSrc,Branch,Zero;  
    wire            Jump;               

    wire [2:0]      ALUControl;         // 3 bits
    wire [1:0]      ALUOp;              // 2 bits


    assign PCSrc        = Branch & Zero;    // AND
    assign WriteReg     = RegDst ? Instr[15:11] : Instr[20:16]; // Set on
    assign SrcB         = ALUSrc ? SignImm : RD2;   // Set on
    assign WD3          = MemtoReg ? ReadData : ALUResult;  // Set on
    assign WriteData    = RD2;

    // Instantation of PC_Counter
    PC_Counter u_PC_Counter(  
        .clk(clk),
        .rst_n(rst_n),
        .PC(PC),
        .PCSrc(PCSrc),
        .Jump(Jump),
        .Jump_low_26Bit(Instr[25:0]),
        .SignImm(SignImm)
    );

    // Instantation of Instr_Memory
    Instr_Memory u_Instr_Memory( 
        .RD(Instr),
        .A(PC)
    );

    // Instantation of Control_Unit
    Control_Unit u_Control_Unit( 
        .clk(clk),
        .rst_n(rst_n),
        .Opcode(Instr[31:26]),
        .MemWrite(MemWrite),
        .RegWrite(RegWrite),
        .RegDst(RegDst),
        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .ALUOp(ALUOp),
        .Jump(Jump),
        .Branch(Branch)
    );

    // Instantation of Reg_File
    Reg_File u_Reg_File( 
        .clk(clk),
        .A1(Instr[25:21]),
        .RD1(SrcA),
        .A2(Instr[20:16]),
        .RD2(RD2),
        .A3(WriteReg),
        .RegWrite(RegWrite),
        .WD3(WD3)
    );

    // Instantation of Imm_Sign_Extend
    Imm_Sign_Extend u_Imm_Sign_Extend( 
        .Immediate(Instr[15:0]),
        .SignImm(SignImm)
    );

    // Instantation of Data_Memory
    Data_Memory u_Data_Memory( 
        .clk(clk),
        .rst_n(rst_n),

        .A(ALUResult),
        .RD(ReadData),
        .WE(MemWrite),
        .WD(WriteData)
    );

    // Instantation of ALU_Control_Unit
    ALU_Control_Unit u_ALU_Control_Unit( 
        .Funct(Instr[5:0]),
        .ALUOp(ALUOp),
        .ALUControl(ALUControl)
    );

    // Instantation of ALU
    ALU u_ALU( 
        .SrcA(SrcA),
        .SrcB(SrcB),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );

endmodule