`timescale 1ns / 1ps

module fir_top#(parameter D_W   = 12,
                parameter C_W   = 12,
                parameter C_NUM = 31)
    (
        input                           clock,
        input                           reset,
        input  logic signed [11:0]      fir_in,
        output logic signed [11:0]      fir_out
    );

   genvar i;
   int j;
   
   logic signed [C_W-1:0] coeff_mem [0: C_NUM-1];
   
   initial begin
    $readmemh("coefficients.mem", coeff_mem);
   end
   
   localparam MULT_WIDTH = D_W + C_W;
   localparam FIR_WIDTH  = MULT_WIDTH + C_NUM - 1;
   
   logic signed [C_NUM-1:0][D_W-1:0]         b_out;
   logic signed [C_NUM-1:0][D_W+C_NUM-1:0] c_out;
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
    c_out[0] <= 0;
   end
    
endmodule
