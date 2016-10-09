`timescale 1ns / 1ps

module MAC
#(  parameter B_WIDTH = 12,
    parameter C_WIDTH = 12,
    parameter COEFF_W = 16,
    parameter C_OUT = C_WIDTH + 1)
    (
    input clock,
    input reset,
    
    input logic  signed [COEFF_W - 1:0] coeff,
    input logic  signed [B_WIDTH - 1:0] b_in,
    input logic  signed [C_WIDTH - 1:0] c_in,
    output logic signed [B_WIDTH - 1:0] b_out,
    output logic signed [C_OUT   - 1:0] c_out
    );
    
    localparam MULT = COEFF_W + B_WIDTH;
    
    logic signed [MULT    - 1:0] mult_cb;
    logic signed [C_OUT   - 1:0] sum_cb;
    
    logic signed [COEFF_W - 1:0] coeff_d;
    logic signed [C_WIDTH - 1:0] c_in_d; 
    
    
    always @(posedge clock)
    begin
        if(reset) begin
            b_out   <= 0;
            c_in_d  <= 0;
            coeff_d <= 0;
        end else begin
            b_out     <= b_in;
            c_in_d    <= c_in;
            coeff_d   <= coeff;
        end
    end
    
    always @(posedge clock)
    begin
        if(reset) begin
            mult_cb <= {MULT{1'b0}};
        end else begin
            mult_cb <= coeff_d * b_out;
        end
    end
    
    always @(posedge clock)
    begin
        if(reset) begin
            sum_cb <= {C_OUT{1'b0}};
        end else begin
            sum_cb <= c_in_d + mult_cb;
        end
    end
    
    assign c_out = sum_cb;
    
endmodule
