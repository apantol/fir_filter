`timescale 1ns / 1ps

module fir_top#(parameter D_W   = 16,
                parameter C_W   = 12,
                parameter C_NUM = 32)
    (
        input                      clock,
        input                      reset,
        input  logic signed [11:0] fir_in,
        output logic signed [11:0] fir_out
    );

   genvar i;
   
   logic signed [C_W-1:0] coeff;
   logic signed [D_W-1:0]  b_out;
   logic signed [C_W+D_W-2:0] c_out;
   
   generate
      for (i=1;i < C_NUM+1; i=i+1)
      begin:
      
         MAC MAC
         #( .B_WIDTH (D_W), .C_WIDTH (C_W+i), .COEFF_W (C_W))
         (
            .clock   (clock),
            .reset   (reset),
            .coeff   (coeff[i]),
            .b_in    (b_out[i]),
            .c_in    (c_out[i]),
            .b_out   (b_out[i+1]),
            .c_out   (c_out[i+1])
           );
           
           assign fir_out = c_out[C_NUM];
           assign b_out[0] = fir_in;
           assign c_out[0] = 0;
           
      end
   endgenerate
    
endmodule
