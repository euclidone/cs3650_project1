module Instr_Memory(
    // System Clock
    input   [31:0]  A, // 32 bits 8 instructions of 5 bits, width of 32 bit
    output  [31:0]  RD // 32 bits Read data

    // User Interface
    
);
	reg [7:0] Instr_Reg [71:0];
	initial begin
		$readmemh("./memfile.dat",Instr_Reg,0,71); // Reading the 18 machine codes
        // in memfile.dat
	end
    assign RD = {{Instr_Reg[A]},{Instr_Reg[A+32'd1]},{Instr_Reg[A+32'd2]},{Instr_Reg[A+32'd3]}};
	// ex: add $t0 $s1 $s2 

endmodule