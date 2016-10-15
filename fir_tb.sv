	`timescale 1ns / 1ps
	
	module fir_tb();

		logic clock = 0;
		logic reset = 0;
		logic signed [11:0] fir_in = 0;
		logic signed [11:0] fir_out;

		always #1 clock = ~clock; 

		task reset_system();
			reset = 1'b1;
			repeat(10) @ (posedge clock);
			reset = 1'b0;
			repeat(100) @ (posedge clock);
		endtask : reset_system

		task dirac_test();
			fir_in =  12'h7FF;
			@ (posedge clock);
			fir_in =  12'h000;
			@ (posedge clock);
		endtask : dirac_test
		
		task wave_from_file();
		  int fid2;
		  int index;
		  fid2 = $fopen("C:/Users/Arek/simulations/sine_in.txt", "r");
		  
		  for(index = 0; index < 2048; index++) begin
		      @(posedge clock);
		      $fscanf(fid2, "%d\n", fir_in);
		  end
		endtask
		
		task capture_data(int samples);
		  int fid1;
		  int x;
		  fid1 = $fopen("C:/Users/Arek/simulations/sine_out.txt", "w");
		  
		  for(x = 0; x < samples; x++) begin
		      @(posedge clock);
		      $fwrite(fid1, "%d\n", fir_out);
		  end    
		endtask

		initial begin
			reset_system();
			dirac_test();
			
			repeat (100) @(posedge clock);
			
			fork
			 wave_from_file();
			 capture_data(2048);
			join

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