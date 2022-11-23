module Reg_File (
    input               clk,
    input       [4:0]   A1, // 5 bits Address 1
    input       [4:0]   A2, // 5 bits Address 2
    input       [4:0]   A3, // 5 bits Address 3
    input               RegWrite, // Will there be writing in the register
    input       [31:0]  WD3, // 32 bits Write data in 3
    
    output  reg [31:0]  A, // Address A
    output  reg [31:0]  B // Address B

);
    // lw : load word instr [op(6bit) rs(5bit) rd(5bit) imm(16bit)]
    wire [31:0] RD1,RD2; // 32 bits Read Data 1 and 2
    reg [31:0]  ROM [31:0];
    // Setting indices 0-15 of ROM to 32 bits of 0s
    initial begin
        ROM[0] <= 32'b0;
        ROM[1] <= 32'b0;
        ROM[2] <= 32'b0;
        ROM[3] <= 32'b0;
        ROM[4] <= 32'b0;
        ROM[5] <= 32'b0;
        ROM[6] <= 32'b0;
        ROM[7] <= 32'b0;
        ROM[8] <= 32'b0;
        ROM[9] <= 32'b0;
        ROM[10] <= 32'b0;
        ROM[11] <= 32'b0;
        ROM[12] <= 32'b0;
        ROM[13] <= 32'b0;
        ROM[14] <= 32'b0;
        ROM[15] <= 32'b0;
    end


    assign RD1 = ROM[A1]; // Assign RD1 to the data stored in ROM at address 1
    assign RD2 = ROM[A2]; // Assign RD2 to the data stored in ROM at address 2
    // RegWrite is set to 1 when lw Instr is executed
    always @(posedge clk) begin // On positive edge 
        A <= RD1; // Address A is set to RD1
        B <= RD2; // Address B is set to RD2
        if (RegWrite) begin // If we want to write the word into the register
            // load word
            ROM[A3] <= WD3; // Store the data in WD3 into ROM at address 3
        end
    end
endmodule