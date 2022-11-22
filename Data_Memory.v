module Data_Memory(
    // System Clock
    input        clk,   // clock
    input        rst_n, // reset

    // User Interface
    input           [31:0]  A,  // 32 bits Write Address A
    input           [31:0]  WD, // 32 bits Write data
    input                   WE,

    output   reg    [31:0]  RD  // 32 bits Read data
);
    integer fd;
    reg [31:0]  DATA_MEM[84:0];

    always @(*) begin
            RD = DATA_MEM[A]; // Data being read from Address A
    end


    initial begin
        fd = $fopen("./MEM_Data.txt", "w");  // fd is set to opening MEM_Data.txt and
        // putting the mode to write
        #500
        $fclose(fd); // close
    end

    always @(posedge clk) begin // On positive clock edge
        if (WE) begin
            DATA_MEM[A] <= WD; // Data stored in memory at address A is given value WD
            $fdisplay(fd,"The Write Address A is %h", A);
            $fdisplay(fd,"DATA_MEM[A] is %h", WD);
        end
    end

endmodule