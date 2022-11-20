module Imm_Sign_Extend(
    // System Clock

    // User Interface
    input       [15:0]  Immediate, //number to sign extend
 
    output      [31:0]  SignImm //sign extended result
);
    assign  SignImm = {{16{Immediate[15]}}, Immediate[15:0]}; //how it is sign extended
endmodule