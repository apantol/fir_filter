`timescale 1ns / 1ps

module fir_top#(parameter D_W   = 12,
                parameter C_W   = 18,
                parameter C_NUM = 49)
    (
        input                      clock,
        input                      reset,
        input  logic signed [11:0] fir_in,
        output logic signed [66:0] fir_out
    );

   genvar i;
   int j;
   
   logic signed [C_NUM-1:0][D_W-1    :0] b_out;
   logic signed [C_NUM-1:0][66:0] c_out;
   
   
   initial begin
        for(j = 0; j < C_NUM; j=j+1) begin
            b_out[j] <= 0;
            c_out[j] <= 0;
        end
   end
   
   logic signed [C_NUM-1:0][C_W-1:0] coeff_mem = '{
   18'h3fdfd,
   18'h3fdc2,
   18'h3fea9,
   18'h000de,
   18'h003d8,
   18'h005f4,
   18'h004f1,
   18'h3ff83,
   18'h3f70e,
   18'h3f02c,
   18'h3f0d2,
   18'h3fc76,
   18'h01054,
   18'h0228e,
   18'h025f5,
   18'h01181,
   18'h3e7f2,
   18'h3bad8,
   18'h3a5e1,
   18'h3c33d,
   18'h01de3,
   18'h0a8b9,
   18'h13fdb,
   18'h1b4d5,
   18'h1e0d8,
   18'h1b4d5,
   18'h13fdb,
   18'h0a8b9,
   18'h01de3,
   18'h3c33d,
   18'h3a5e1,
   18'h3bad8,
   18'h3e7f2,
   18'h01181,
   18'h025f5,
   18'h0228e,
   18'h01054,
   18'h3fc76,
   18'h3f0d2,
   18'h3f02c,
   18'h3f70e,
   18'h3ff83,
   18'h004f1,
   18'h005f4,
   18'h003d8,
   18'h000de,
   18'h3fea9,
   18'h3fdc2,
   18'h3fdfd};
         
   generate
      for (i=0;i < C_NUM; i=i+1)
      begin: mult_acc MAC
         #( .B_WIDTH (D_W), .C_WIDTH (C_W+i), .COEFF_W (C_W))
         inst_mac(
            .clock   (clock),
            .reset   (reset),
            .coeff   (coeff_mem[i]),
            .b_in    (b_out[i]),
            .c_in    (c_out[i]),
            .b_out   (b_out[i+1]),
            .c_out   (c_out[i+1])
           );
           
      end
   endgenerate

   always @(posedge clock)
   begin
    fir_out <= c_out[C_NUM-1];
    b_out[0] <= fir_in;
    c_out[0] <= 0;
   end
    
endmodule
