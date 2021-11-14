module band_scale_rnd_tb();

	reg [27:0] stim;
	reg [15:0] scaled_golden;
	wire [11:0] POT;
	wire [15:0] audio;
	assign POT = stim[27:16];
	assign audio = stim[15:0];
	wire [15:0] scaled;
	band_scale iDUT(.scaled(scaled), .POT(POT), .audio(audio));
	reg [27:0] mem_stim [0:999];
	reg [15:0] mem_expect [0:999];
	integer x;
	
	initial begin	
		/////////read corresponding files///////////
		$readmemh("band_scale_stim.hex", mem_stim);
		$readmemh("band_scale_resp.hex", mem_expect);
		for (x=0; x<1000; x=x+1)begin
			stim = mem_stim[x];
                        #1;
			scaled_golden = mem_expect[x];
			if (scaled !== scaled_golden) begin
				$display("Error at number %d entry", x);
				$stop();
			end
		end
		$display("congratulations, you passed the test!");
		$stop();
	end
endmodule
