module PC_Counter(
    // System Clock
    input        clk,   // clock
    input        rst_n, // reset

    // User Interface
    input                   PCSrc,
    input                   Jump,
    input           [31:0]  SignImm,        // 32 bits
    input           [25:0]  Jump_low_26Bit, // 26 bits
    output   reg    [31:0]  PC              // 32 bits
);
    wire            [31:0] PC_Next;         // 32 bits
    wire            [31:0] PCPlus4;         // 32 bits
    wire            [31:0] PCBranch;        // 32 bits
    wire            [31:0] PCJump;          // 32 bits


    assign PCPlus4  = PC + 32'd4;                                   // This gets the Progam counter value + 4
    assign PCBranch = (SignImm << 2) + PCPlus4;                     // Value for branching (SignImm shift left once(?))
    assign PCJump   = {{PCPlus4[31:28]},{Jump_low_26Bit},2'b00};    // Value for jumping 
    assign PC_Next  = Jump ? PCJump : (PCSrc ? PCBranch : PCPlus4); // Getting the next Program counter value


    always @(posedge clk) begin // On positive edges
        if(~rst_n)begin
            PC <= 32'b0;    // Initialize with a 32-bit width of all 0s
        end
        else 
            PC <= PC_Next;  // Otherwise just get the next determined PC value
    end

endmodule