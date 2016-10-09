	`timescale 1ns / 1ps
	
	module fir_tb();

		logic clock = 0;
		logic reset = 0;
		logic signed [11:0] fir_in = 0;
		logic signed [65:0] fir_out;

		always #1 clock = ~clock;

		task reset_system();
			reset = 1'b1;
			repeat(10) @ (posedge clock);
			reset = 1'b0;
			repeat(100) @ (posedge clock);
		endtask : reset_system

		task dirac_test();
			fir_in = 12'h0CF;
			@ (posedge clock);
			fir_in = 12'h000;
			@ (posedge clock);
		endtask : dirac_test

		initial begin
			reset_system();
			dirac_test();

		end


		fir_top #(
				.D_W(12)
			) inst_fir_top (
				.clock   (clock),
				.reset   (reset),
				.fir_in  (fir_in),
				.fir_out (fir_out)
			);

endmodule