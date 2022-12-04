# cs3650_project1

Group Guapos
Names:
Angel Zuniga
Josue Garcia
Long Nguyen


## [CS 3650] Project 1: Certified Preowned Processor
https://docs.google.com/document/d/14NbGTFrBg8yicgkqpqA4v2oapyKQLkeV4qZMv2z0rwM/edit?usp=sharing 

## MIPS Single-cycle implementation
Each component (memory, ALU, etc.) can be used only once.
In the file Data_Memory, we use the clock signal to figure out the state of the memory. So, if the clock has a positive edge and the Write is set then we write WD to the Data memory at the indicated address. When the clock has a negative edge only the Read is set.
The Instr_Memory is used to hold the instructions and is separate from the Data_Memory.
The Reg_File is similar to Data_Memory in that we use the clock signal to figure out the state of the memory. So, if the clock has a positive edge and the Write is set then we write WD to the Data memory at the indicated address. When the clock has a negative edge only the Read is set. Except there are 3 input addresses and 2 outputs. The register also initializes a set of 16 32-bit vectors.
The ALU has various arithmetic and logical operations. We have 3 inputs, 2 sources and one control unit that dictates which operation we will perform. Then there is 1 output, which is the result, we also set the zero variable.
The Control_Unit dictates the instruction being outputted and how each register is set. The input Opcode dictates which instruction is used.
ALU_Control is controlled by the ALU and takes in the funct field and the opcode input. The opcode dictates the instructions and then funct dictates the operation. The operation could be add, subtract, AND, OR, or set on less than.
PC_Counter outputs the PC value, depending on if the clock edge is positive and there is a negative reset then the PC is initialized with a 32 bit of 0s value. If that is not the case, then the PC gets the next determined PC value.
Imm_Sign_Extend is a simple implementation where if a 16 bit value is inputted it copies the sign bit of the unextended value to all the bits on the left side of the larger-size value.
In the MIPS_Single_Cycle file we module instantiations of all the files involved in the single cycle process. It is primarily used to connect all the modules through wires, where they are all waiting for the clock and reset variables from the testbench to set the reset of the wires.
The tb_ MIPS_Single_Cycle is where we simulate results without hardware. In our test bench we test by setting the clock, reset, and count to 0. Then the clock to 1, and then back to 0 along with the reset being changed to one. After we negate the clock variable in order to add 1 bit of 1 to count and to stop once the count reaches 17. All together this will execute 17 times before the testbench will stop itself.

# ALU.v
 Inputs
2, 32 bit values from two files?
3-bit ALUControl register that has the output from the ALU control unit.
 Dictates what operation will happen
Case module
Takes account for the ALUControl input
Conducts 3 different actions
Add
Subtract
Logical: AND, OR, set less than
Outputs
ALUControl returns the ALUResult
Zero returns set on
ALU_Control_Unit.v
Inputs
Funct field 6-bits: dictates what operation is returned as ALUControl
ALUOp 2-bit: dictates lw,sw, or beq
Case module
Takes account for the ALUOp input
Operation lw  -> add, subtract, AND, OR, set on less than
Operation sw -> add
Operation  beq -> subtract
Outputs
ALUControl is a 3-bit output that is sent to ALU.v to make operation happen.
Control_unit.v
Inputs
clk or clock – updates all state elements on the same clock edge
rst or reset – initializes hardware
Opcode 6-bit: dictates instruction
Case module
Takes account for the Opcode input
Contains 6 instruction
R-type, beq, sw, lw, addi, j
Each instruction triggers 1 of 8 signals
RegWrite, RegDst, ALUSrc, Branch, MemWrite, MemtoReg, ALUOp, Jump
Outputs
The outputs are the 8 different signals from the case module.
Not all will be outputted but each signal has its own register to output
 
Data Memory
Inputs
clk or clock – updates all state elements on the same clock edge
rst or reset – initializes hardware
A or address
RD or read data
First always module
Assigns 32-bit data memory to RD input
Initial module
Opens memory data text file and assigns write to fd, the closed.
Second module
Imm_SignExtend
Inputs
Immediate 16-bit: number to extend
Outputs
SignImm 32-bit: sign extended number of Immediate
Assign SignImm
contains the result of the sign extending immediately.
Instr_Memory
Inputs
A: 8 instructions of 5 bits, width of 32-bits
Initial module
Reads instruction from memory file
Outputs
RD: 32 bit instructions
MIPS_Single_Cycle
Inputs
clk or clock – updates all state elements on the same clock edge
rst or reset – initializes hardware
Wires
Connecting all other Verilog files
Instantiations
All other Verilog files.
PC_Counter
Inputs
clk or clock – updates all state elements on the same clock edge
rst or reset – initializes hardware
PRSrc – Asserted :adder computed by branch target/Deasserted:adder that computes the value of  PC + 4
Jump
SignImm
Jump_low_26Bit
Outputs
Register PC
Wires
PC_Next
PLCPus4
PCBranch
PCJump
Assigns
PCPlus4
PCBranch
PCJump
PC_Next
Always module
If the hardware has not been initialized, will initialize with 32 bits of 0s
Reg_File.v
Inputs
clk or clock – updates all state elements on the same clock edge
A1, A2, A3 5-bit: addresses to be read
RegWrite: register that is written?
WD3 32-bit: write data
register ROM
used to load initial values
Outputs
RD1, RD2 32-bit: Holds the 32 bit addresses that will come from memory
Initial module
Loading word instruction of 32 bit
Always module
RegWrite is set to 1 when lw Instruction is executed
Tb_MIPS_Single_Cycle
Registers
Clk, rst_n
Cnt 32-bit
First initial module
Holds the vcd file to test
Second initial module
Begins aa sequence of assigning bits to clk, rst_n, cnt
Time delays between each assignment block
Always
Executes when clk to 0 from 1
Adds 1 bit pf 1 to clk
Instantiation of MIPS_Single_Cycle
Assigns the values clk and rst_n from MIPS_Single_Cycle to the tb


## MIPS Multi-cycle implementation
Each component (memory, ALU, etc.) can be used more than once in an instruction as long as it is used in different clock cycles.
Similarly, to the ALU file in the single cycle implementation, The ALU file for the multi-cycle implementation dictates the same arithmetic and logical operations. However, this ALU takes into account 7 inputs. The addresses for A and B, flags for each address, PC value, sign immediate value, and the ALU control unit. Where the 2 bit ALU rcB dictates if the address for B can be calculated, if the address will be the 32 bit decimal for 4, sign immediate value, or the left shifted value of sign immediate.
The ALU_Control_Unit file is exactly the same as the ALU control unit for a single cycle.
Control_Unit has the same 3 inputs as clock, reset, and opcode, but since there are more stages in multicycle it outputs 1 bit flags that account for those stages. Along with another 2 bit outputs for the PC source and ALU source B. There are also 4 constants that are used to calculate the stages and 2 4 bit registers used to determine the current and next state. There is a funct field case that outputs the instruction dictated by the current state and the operation is dictated by the next state. Then if the clock has a positive edge and the reset is negated the current state is set to fetch, if not then the next state is the current state.
The Imm_Sign_Extend file is the same as the single cycle implementation.
The Instr_Data_Memory file reads the data from a file and depending on what flag is set. If the instruction write flag is set, then the data is set to the instruction. If the memory write flag is set the data is set to the instruction data memory register.
PC_Counter relies on the PC source, clock, reset, and the PC encoded flag. So, if the instruction or data is equal to the PC then ALUOut address is set to the address to output. Now the PCSrc bits dictate if the ALUResult is the next PC, if the ALUOut is the next PC, or if the last 4 bits of the PC is the next PC. Then if the clock has a positive edge and the reset is negated then the PC is reset to 0. If the PC encoded flag is set then the next PC is the current PC.
Reg_File is similar to the Reg_File in single cycle as it makes a set of 32 bit vectors, but it uses the memory in ROM to store the data from the input RD1 to Address1, and it does the same for RD1 and A2. Then both RD! and RD! are set to A and B. The next thing is if the RegWrite flag is set then the data in WD3 is set to A3 in the ROM.
The MIPS_Multi_Cycle has the instantiations of all the files used in the multicycle implementation. Along with three variables that are dictated by the wires from the other modules.
The tb_MIPS_Multi_Cycle is very similar to the single cycle implementation, the only thing that is different is that the count will stop once the count reaches 72 instead of 17.

# ALU_Control_Unit.v 
is the same as single cycle

# ALU.v
PC - Program Counter
ALUSrcA/ALUSrcB - Current addresses A and B in the ALU
SignImm - Sign-extended number
First decides on the value of SrcB using a switch statement with input ALUSrcb
Then decides on the operation based on the ALUControl value and stores it in ALUResult
At the end, on positive edges, it will set ALUOut to ALUResult

# Control_Unit.v
3 inputs and 12 outputs are declared
12 parameters are declared
2 extra registers Current_State and Next_State are made to track states
Enters a switch statement with Current_State as input where it chooses an operation from the 12 previously-declared parameters
Goes into another switch statement using Current_State
Picks another operation
Then decides to set current state to fetch or next_state depending on if reset is true or not

# Imm_Sign_Extend.v
Same as single cycle

# Instr_Data_Memory.v
First 5 inputs are created: clk, A, WD, IRWrite, Memwrite
2 inputs Instr and Data are created
An integer fd is created
A 32-bit wire RD is created
One last register Instr_Data_Mem is created
Read memory operation is performed to read from ./memfile.dat
Fd is then set to ./MEM_Data.txt with mode set to write then closes after a short delay
Assign Rd to the addresses A, A + 1, A + 2, A + 3
On each positive edge set data to rd
If write instruction is true, set Instr to the value in RD
If we want to write to memory, set Instr_Data_Mem[A], Instr_Data_Mem[A + 1], Instr_Data_Mem[A + 2], Instr_Data_Mem[A + 3] to WD
Finally, display data

# MIPS_Multi_Cycle.v
Creates 2 inputs clk, rst_n
Creates 19 wires: PC, ALUResult, SignImm, ALUOut, Instr, Data, A, B, Adr, WriteRegData, ALUControl, ALUOp, PCSrc, WriteReg, ALUSrcB, ALUSrcA, MemWrite, RegWrite, IorD, RegDst, ALUSrc, MemToReg, Branch, Zero, PCEn, PCWrite, IRWrite
Assigns the value of PCEn
Assigns the value of WriteReg
Assigns the value of WriteRegData
Then it instantiates: PC_Counter, Instr_Data_Memory, Control_Unit, Reg_File, Imm_Sign_Extend, ALU_Control_Unit, ALU

# PC_Counter.v
Creates 8 inputs clk, rst_n, PCEn, IorD, PCSrc, Jump_low_26Bit, ALUOut, ALUResult
Creates  2 outputs Adr and PC
Creates a final register PC_Next to store the next Program Counter value
Gets the value of Adr depending on if it is equal to IorD or not
The next process is to calculate PC + 4 using the ALU
Get the value PC_Next depending on the input PCSrc
On positive clock edges, check if rst_n is false which if it is false reset the Program Counter
Else if PCEn is true set Program Counter to PC_Next

# Reg_File.v
Creates 6 inputs: clk, A1, A2, A3, RegWrite, WD3
Creates 2 output registers A, B
Creates 2 wires RD1, RD2
Creates one more register ROM of size 32 bits
Sets each bit of ROM to 32 0s
Assigns the values of RD1 and RD2
On positive clock edges, set A to RD1 and set B to RD2
If we want to write to the register, load WD3 into ROM[A3]
Done

# tb_MIPS_Multi_Cycle.v
Creates 3 registers: clk, rst_n, cnt
Dumps the content to MIPS_wave.vcd and assigns the dump variable to 	tb_MIPS_Multi_Cycle
Values of clk, rst_n, and cnt are changed with small time delays between them
A continuous block begins that sets clk to the negation of clk after 10 ps
On negative edges set cnt to cnt + 1
If cnt reaches or surpasses 72 then stop it
Finally, instantiate MIPS_Multi_Cycle


## MIPS_Pipeline
Pipeline should work together with MIPS_Multi_Cycle to optimize the outcome of the result.
The 5 stages of pipeline are:
IF: Instruction fetch
ID: Instruction decode and register file read
EX: Execution or address calculation
MEM: Data memory access
WB: Write back.
When done right the pipelining method should help in improving instruction throughput instead of execution time. Furthermore, the speedup from pipelining is equal to the number of pipeline stages. One of the dangers of using pipelining is that data hazards could occur. Data hazard is when the machine attempts to execute a task before it is ready. One of the solutions to Data hazard is to just stall until the task is ready.

The ALU_Control_Unit is the same as in multi and single cycle.
The ALU file is completely different from the other two implementations. Since there are 5 stages in pipelining then there are more inputs to take into account, but with the same amount of outputs. The wire that would connect the module to others is dictated if the source for the ALU value is the same as the SrcB_Forward value then it is assigned the SignImm value. Now if the reset is negated then the source for address A and the forwarded source B to 0. If the reset is not negated then depending on ForwardAE then the source address for A could be the RD1E, ResultW, or ALUOutM. The same is true for ForwardBE as the source address for B could be RD2E, ResultW, or ALUOutM. Then the arithmetic or logical operation will be executed.
Control_Unit is the same one used in a single cycle.
The Data_Memory is the same one used in a single cycle.
IF/ID is the instruction fetch stage where a new instruction is fetched every cycle, the current PC is the index to the instruction memory and the PC is incremented at the end of every cycle if there are no branches. The instruction bits to decode for later are in the pipeline register and the PC is incremented by for to compute branch targets for later. The Instruction decode stage reads the data from the register file and the IF/ID pipeline register, decodes the instruction, and generates the appropriate control signals. It also initializes the value that adds 4 to the PC and the decoded instruction, only if the rest is negated. If reset is not negated then the flags for the decoded PC source and decoded jump are compared then it initializes the value that adds 4 to the PC and the decoded instruction. Then if the stall decoded flag is set then the value that adds 4 to the PC and the decoded instruction are set to themselves. Then if the other conditions are not met then the value that adds 4 to the PC from the fetch is combined with the same one that is for the decoded stage and the instruction that is decoded is combined with the original instruction.
ID/EX is the execution stage where it reads the pipeline register and performs the SLU operation, deciding to compute the targets in case of a branch. Then decides if a jump or branch should be taken. It also decodes the instruction and generates the control signals read from the register file. If the reset is negated the register to write execute, memory to register execute, memory write execute, register destination execute, ALU source execute, and the ALU control execute is set to 0. If the reset is not negated and the Flush execute flag is set the register write execute and memory register execute registers are set to 0. Now if both conditions are not met then all the variables that are decoded and executed are combined.
Just like the IF/ID and ID/EX files the EX/MEM the stages are combined between the execute and memory stage. The memory stage performs the appropriate load or store operations if needed. It also has a few conditions to execute if the parameters are met. If the reset is negated than the sermo memory, register write memory, memory to register memory, and memory write memory is initialized to 0. All else the memory variable and the execute variables are combined.
Imm_Sign_Extend is the same as the other implementations.
The Instr_Memory file is the same as the other implementations.
The PC_Counter is similar to other implementations, but there is a condition that depends on the tall flag. If it is set then the PC is assigned to itself. It also calculates the values of the next PC value, the PC jump value, the value of the PC plus 4 and the same value is assigned to the flush variable of the PC plus 4, and then the address to dictate if it is a jump or next PC.
The Reg_File is the same as the other implementations.
The Stall_Unit file dictates whether to stall any of the stages; fetch, decode, memory, execute, or write back. It first calculates if the branch stall should be set and if the load word stall flag should be set as well. Now if the reset is negated then the flush execute flag, stall decode flag, and stall fetch flags are set to 0. Now if the load word or branch stall flag is set then the flush execute, stall decode, and stall fetch is set. If either of those conditions are not met, then the flush execute, stall decode, and stall fetch is set to 0.
The MIPS_Pipeline file has the instantiations of all the other modules along with the correct wires connecting those modules. There is also the calculation of two variables: the result of write and the write execute register.
The tb_MIPS_Pipeline is the same as the other test benches in the single and multicycle implementations. Except the count will stop at 25, which is write in the middle of the single and multicycle implementations

# ALU_Control_Unit.v
There are 2 inputs: Funct and ALUOp
There is output register: ALUControl
Switch statement based on ALUOp where if it is 00 then set ALUControl to subtraction
If ALUOp is 2 then go to the nested switch statement
This switch statement is based on the input Funct
If it equals 100000 then do subtraction
If it equals 100010 then do OR
If it equals 100100 then do Addition
If it equals 100101 then do increment
If it equals 101010 then do AND
After exiting the switch statement, check if the value of ALUControl was instead 01

 

