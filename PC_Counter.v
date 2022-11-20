module PC_Counter(
    // System Clock
    input        clk,
    input        rst_n,

    // User Interface
    input                   PCSrc,
    input                   Jump,
    input           [31:0]  SignImm,
    input           [25:0]  Jump_low_26Bit,
    output   reg    [31:0]  PC
);
    wire            [31:0] PC_Next;
    wire            [31:0] PCPlus4;
    wire            [31:0] PCBranch;
    wire            [31:0] PCJump;


    assign PCPlus4  = PC + 32'd4;
    assign PCBranch = (SignImm << 2) + PCPlus4;
    assign PCJump   = {{PCPlus4[31:28]},{Jump_low_26Bit},2'b00}; 
    assign PC_Next  = Jump ? PCJump : (PCSrc ? PCBranch : PCPlus4);



    always @(posedge clk) begin
        if(~rst_n)begin
            PC <= 32'b0;
        end
        else 
            PC <= PC_Next;
    end

endmodule