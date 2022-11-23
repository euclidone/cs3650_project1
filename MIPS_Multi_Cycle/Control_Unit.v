module Control_Unit(
    // System Clock
    input        clk,
    input        rst_n,

    // User Interface

    input       [5:0]   Opcode, // 6 bit opcode used later to decide the operation

    output  reg [1:0]   ALUOp, // 1 bit for operation
    output  reg         MemtoReg, // Will data be passed from memory to register
    output  reg         RegDst, // Destination Register
    output  reg         IorD, // Instruction or data
    output  reg [1:0]   PCSrc, // Program Counter src
    output  reg [1:0]   ALUSrcB, // Address Src B in ALU
    output  reg         ALUSrcA, // Address Src A in ALU

    output  reg         IRWrite, // Instruction write or not
    output  reg         MemWrite, // Write in memory or not
    output  reg         PCWrite, // Write in program counter or not
    output  reg         Branch, // Branch or not
    output  reg         RegWrite // Write in register or not
);

    parameter   S0_Fetch   = 4'd0, S1_Decode       = 4'd1, S2_MemAdr   = 4'd2;
    parameter   S3_MemRead = 4'd3, S4_MemWriteback = 4'd4, S5_MemWrite = 4'd5;
    parameter   S6_Execute = 4'd6, S7_ALU_Writeback= 4'd7, S8_Branch   = 4'd8;
    parameter   S9_ADDI    = 4'd9, S10_ADDI_Writeback=4'd10,S11_Jump   = 4'd11;
    reg [3:0]   Current_State, Next_State;  // 2 regisers used to determine current state and next state

/*******************************************************************************
 *                                 Main Code
*******************************************************************************/

    always @(*) begin
        // switch statement with Current_State as the input
        case(Current_State)
            // initialize with fetch as the input
            S0_Fetch : begin
                IorD    = 1'b0;
                ALUSrcA = 1'b0;
                ALUSrcB = 2'b01;
                ALUOp   = 2'b00;
                PCSrc   = 2'b00;

                IRWrite = 1'b1;
                MemWrite= 1'b0;
                PCWrite = 1'b1;
                Branch  = 1'b0;
                RegWrite= 1'b0;
            end
            // initialize with decode as the input
            S1_Decode : begin
                ALUSrcA = 1'b0;
                ALUSrcB = 2'b11;
                ALUOp   = 2'b00;

                IRWrite = 1'b0;
                MemWrite= 1'b0;
                PCWrite = 1'b0;
                Branch  = 1'b0;
                RegWrite= 1'b0;
            end
            // initialize with MemAdr as the input
            S2_MemAdr : begin
                ALUSrcA = 1'b1;
                ALUSrcB = 2'b10;
                ALUOp   = 2'b00;

                IRWrite  = 1'b0;
                MemWrite = 1'b0;
                PCWrite  = 1'b0;
                Branch   = 1'b0;
                RegWrite = 1'b0;
            end
            // initialize with MemRead as input
            S3_MemRead : begin
                IorD     = 1'b1;

                IRWrite  = 1'b0;
                MemWrite = 1'b0;
                PCWrite  = 1'b0;
                Branch   = 1'b0;
                RegWrite = 1'b0;
            end
            // initialize with MemWriteBack as input
            S4_MemWriteback : begin
                RegDst   = 1'b0;
                MemtoReg = 1'b1;

                IRWrite  = 1'b0;
                MemWrite = 1'b0;
                PCWrite  = 1'b0;
                Branch   = 1'b0;
                RegWrite = 1'b1;
            end
            // initialize with MemWrite as input
            S5_MemWrite : begin
                IorD     = 1'b1;

                IRWrite  = 1'b0;
                MemWrite = 1'b1;
                PCWrite  = 1'b0;
                Branch   = 1'b0;
                RegWrite = 1'b0;
            end
            // initialize with execute as input
            S6_Execute : begin
                ALUSrcA  = 1'b1;
                ALUSrcB  = 2'b00;
                ALUOp    = 2'b10;

                IRWrite  = 1'b0;
                MemWrite = 1'b0;
                PCWrite  = 1'b0;
                Branch   = 1'b0;
                RegWrite = 1'b0;
            end
            // initialize with ALU WriteBack as input
            S7_ALU_Writeback : begin
                RegDst   = 1'b1;
                MemtoReg = 1'b0;

                IRWrite  = 1'b0;
                MemWrite = 1'b0;
                PCWrite  = 1'b0;
                Branch   = 1'b0;
                RegWrite = 1'b1;
            end
            // initialize with branch as input
            S8_Branch : begin
                ALUSrcA  = 1'b1;
                ALUSrcB  = 2'b00;
                ALUOp    = 2'b01;
                PCSrc    = 2'b01; 

                IRWrite  = 1'b0;
                MemWrite = 1'b0;
                PCWrite  = 1'b0;
                Branch   = 1'b1;
                RegWrite = 1'b0;
            end
            // initialize with addi as input
            S9_ADDI : begin
                ALUSrcA  = 1'b1;
                ALUSrcB  = 2'b10;
                ALUOp    = 2'b00;

                IRWrite  = 1'b0;
                MemWrite = 1'b0;
                PCWrite  = 1'b0;
                Branch   = 1'b0;
                RegWrite = 1'b0;
            end
            // initialize with addi_writeback as input
            S10_ADDI_Writeback : begin
                RegDst   = 1'b0;
                MemtoReg = 1'b0;

                IRWrite  = 1'b0;
                MemWrite = 1'b0;
                PCWrite  = 1'b0;
                Branch   = 1'b0;
                RegWrite = 1'b1;
            end
            // initialize with jump as input
            S11_Jump : begin
                PCSrc    = 2'b10;

                IRWrite  = 1'b0;
                MemWrite = 1'b0;
                PCWrite  = 1'b1;
                Branch   = 1'b0;
                RegWrite = 1'b0;
            end
        endcase 
    end

    always @(*) begin
        // switch statement with Current_State as input
        case(Current_State)
            S0_Fetch : Next_State = S1_Decode; // If fetch is the current state, next state is decode
            S1_Decode : begin // If it is decode:
                case(Opcode)
                    // OP = lw or sw
                    6'b100011,6'b101011 : Next_State = S2_MemAdr;
                    // Op = R-type
                    6'b000000: Next_State = S6_Execute;
                    // Op = Beq
                    6'b000100: Next_State = S8_Branch;
                    // Op = addi
                    6'b001000: Next_State = S9_ADDI;
                    // Op = Jump
                    6'b000010: Next_State = S11_Jump;
                endcase 
            end
            S2_MemAdr : begin // If current state is MemAdr
                // Depending on the OpCode, Next_State will be read or write
                case (Opcode)
                    6'b100011: Next_State = S3_MemRead;
                    6'b101011: Next_State = S5_MemWrite;
                    
                    default: ;
                endcase
            end
            S3_MemRead      : Next_State = S4_MemWriteback; // If it was memread, next state is memwriteback
            S4_MemWriteback : Next_State = S0_Fetch; // if it was memwriteback, next state is fetch
            S5_MemWrite     : Next_State = S0_Fetch; // if it was memwrite, go to fetch
            S6_Execute      : Next_State = S7_ALU_Writeback; // if it was execute, go to alu_writeback
            S7_ALU_Writeback: Next_State = S0_Fetch; // if it was alu_writeback, go to fetch
            S8_Branch       : Next_State = S0_Fetch; // if it was branch, go to fetch
            S9_ADDI         : Next_State = S10_ADDI_Writeback; // if it was addi, go to addi_writeback
            S10_ADDI_Writeback : Next_State = S0_Fetch; // if it was addi_writeback, go to fetch
            S11_Jump        : Next_State = S0_Fetch; // if it was jump, go to fetch
        endcase
    end

    always @(posedge clk) begin // on positive clock edge
        if (!rst_n) begin // If not reset
            Current_State <= S0_Fetch; // Current_State is set to fetch
        end
        else begin
            Current_State <= Next_State; // Current state is set to next state
        end
    end

endmodule