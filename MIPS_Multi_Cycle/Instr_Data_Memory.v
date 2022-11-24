module Instr_Data_Memory(
    // System Clock
	input				clk, // clock
    input   	[31:0]	A, // address a
	input		[31:0]	WD, // write directory
	input				IRWrite, // Instruction write
	input				MemWrite, // memory write

	output	reg	[31:0]	Instr, // instruction register
	output	reg	[31:0]	Data // data register
    // User Interface
    
);
	integer fd;
	wire [31:0] RD; // 32 bit read data
	reg [7:0] Instr_Data_Mem [84:0];

/*******************************************************************************
 *                                 Main Code
*******************************************************************************/

	initial begin
		$readmemh("./memfile.dat",Instr_Data_Mem,0,71); // reading from memory
		fd = $fopen("./MEM_Data.txt", "w");  // fd is set to opening MEM_Data.txt and putting the mode to write
        #1400 // Delay in 1400ps timescale unit
        $fclose(fd); // close
	end

    assign RD = {{Instr_Data_Mem[A]},{Instr_Data_Mem[A+32'd1]},{Instr_Data_Mem[A+32'd2]},{Instr_Data_Mem[A+32'd3]}};
	// RD is set to the data from address A, address A + 1, address A + 2, and address A + 3

	always @(posedge clk) begin // on positive clock edge
		Data <= RD; //  data will be set to the value of Read Data
		if (IRWrite) begin // If we want to write an instruction
			Instr <= RD; // Set the intstruction register to Read Data	
		end
		// Notice : the signal A now is Data Address here
		if (MemWrite) begin // If we would like to write to memory
			{{Instr_Data_Mem[A]},{Instr_Data_Mem[A+32'd1]},{Instr_Data_Mem[A+32'd2]},{Instr_Data_Mem[A+32'd3]}} <= WD;
			// The data in address A, address A + 1, address A + 2, address A + 3 is set to the value of write data
			// Displaying the data 
			$fdisplay(fd,"The Write Address A is %h", A);
            $fdisplay(fd,"DATA_MEM[A] is %h", WD);
		end
	end
endmodule