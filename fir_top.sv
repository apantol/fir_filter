`timescale 1ns / 1ps

// Author: A.P //
// initial version, development still in progress!

// Handcoded single channel FIR filter
// Use 32 DSP units
// Input data format: Q0.15
 
module fir_top#(parameter D_W   = 16,
                parameter C_W   = 16,
                parameter C_NUM = 33)
    (
        input                           clock,
        input                           reset,
        input  logic signed [D_W-1:0]      fir_in,
        output logic signed [D_W-1:0]      fir_out
    );

   genvar i;
   int j;
   
   logic signed [C_W-1:0] coeff_mem [0: C_NUM-1] = {16'h0d9d,  //differentiator filter, TODO: store it in .coeff file
   16'hed3c,
   16'hfb3d,
   16'h18fb,
   16'hee8d,
   16'hfb28,
   16'h03d4,
   16'h12db,
   16'hed1f,
   16'hf3ce,
   16'h1405,
   16'h1453,
   16'hd8e6,
   16'he6de,
   16'h4f28,
   16'h7712,
   16'h0000,
   16'h88ee,
   16'hb0d8,
   16'h1922,
   16'h271a,
   16'hebad,
   16'hebfb,
   16'h0c32,
   16'h12e1,
   16'hed25,
   16'hfc2c,
   16'h04d8,
   16'h1173,
   16'he705,
   16'h04c3,
   16'h12c4,
   16'hf263};

   
   localparam MULT_WIDTH = D_W + C_W;
   localparam FIR_WIDTH  = MULT_WIDTH + C_NUM - 1;
   
   logic signed [C_NUM-1:0][D_W-1:0]         b_out;
   logic signed [C_NUM-1:0][D_W-1:0]         c_out;
   logic signed            [C_W-1:0]         coeff;
   
   
   initial begin
        for(j = 0; j < C_NUM; j=j+1) begin
            b_out[j] <= 0;
            c_out[j] <= 0;
        end
   end
         
   generate
      for (i=0;i < C_NUM; i=i+1)
      begin: mult_acc MAC
         #( .B_WIDTH (D_W), .C_WIDTH (C_W), .COEFF_W (C_W))
         inst_mac(
            .clock   (clock         ),
            .reset   (reset         ),
            .coeff   (coeff_mem[i]  ),
            .b_in    (b_out[i]      ),
            .c_in    (c_out[i]      ),
            .b_out   (b_out[i+1]    ),
            .c_out   (c_out[i+1]    )
           );
      end
   endgenerate

   always @(posedge clock)
   begin
    fir_out  <= c_out[C_NUM-1];
    b_out[0] <= fir_in;
   end
    
endmodule
