module high_freq_queue_tb();
	
	logic clk, rst_n, wrt_smpl;
	logic [15:0] lft_smpl, rght_smpl;
	logic [15:0] lft_out, rght_out;	
	logic sequencing;

	logic fail;

	high_freq_queue iDUT(.clk(clk), .rst_n(rst_n), .wrt_smpl(wrt_smpl), .lft_smpl(lft_smpl), .rght_smpl(rght_smpl), .sequencing(sequencing), .lft_out(lft_out), .rght_out(rght_out));

	integer i;

	initial begin
		clk = 0;
		rst_n = 0;
		wrt_smpl = 0;
		fail = 0;
		@(negedge clk);
		rst_n = 1;

		lft_smpl = 0;
		rght_smpl = 0;
		@(posedge clk);
		
		//Fill queue
		for (i = 0; i < 1531; i = i + 1) begin
			wrt_smpl = 1;
			@(posedge clk);
			wrt_smpl = 0;
			lft_smpl = lft_smpl + 1;
			rght_smpl = rght_smpl + 1;
			@(posedge clk);
		end
			
		//Read data and increment pointers
		wrt_smpl = 1;
		@(posedge sequencing);
		wrt_smpl = 0;
		@(posedge clk);
		for (i = 0; i < 1021; i = i + 1) begin
			@(posedge clk);
			if(lft_out != i || rght_out != i)
			fail = 1;
			
		end

		lft_smpl = 1532;
		rght_smpl = 1532;
		//Read data and increment pointers
		repeat (5) @(posedge clk);
		wrt_smpl = 1;
		@(posedge sequencing);
		wrt_smpl = 0;
		@(posedge clk);
		for (i = 0; i < 1021; i = i + 1) begin
			@(posedge clk);
			if(lft_out != i + 1 || rght_out != i + 1)
			fail = 1;
			
		end

		lft_smpl = 1533;
		rght_smpl = 1533;
		//Read data and increment pointers
		repeat (5) @(posedge clk);
		wrt_smpl = 1;
		@(posedge sequencing);
		wrt_smpl = 0;
		@(posedge clk);
		for (i = 0; i < 1021; i = i + 1) begin
			@(posedge clk);
			if(lft_out != i + 2 || rght_out != i + 2)
			fail = 1;
			else
			fail = 0;
			
		end


		lft_smpl = 1534;
		rght_smpl = 1534;
		repeat (5) @(posedge clk);
		wrt_smpl = 1;
		@(posedge sequencing);
		wrt_smpl = 0;
		@(posedge clk);
		for (i = 0; i < 1021; i = i + 1) begin
			@(posedge clk);
			if(lft_out != i + 3 || rght_out != i + 3)
			fail = 1;
			else
			fail = 0;
			
		end

		lft_smpl = 1535;
		rght_smpl = 1535;
		//Read data and wrap around new pointer
		repeat (5) @(posedge clk);
		wrt_smpl = 1;
		@(posedge sequencing);
		wrt_smpl = 0;
		@(posedge clk);
		for (i = 0; i < 1021; i = i + 1) begin
			@(posedge clk);
			if(lft_out != i + 4 || rght_out != i + 4)
			fail = 1;
			else fail = 0;
			
		end

		lft_smpl = 1536;
		rght_smpl = 1536;
		//Read data that is wrapping around queue
		repeat (5) @(posedge clk);
		wrt_smpl = 1;
		@(posedge sequencing);
		wrt_smpl = 0;
		@(posedge clk);
		for (i = 0; i < 1021; i = i + 1) begin
			@(posedge clk);
			if(lft_out != i + 5 || rght_out != i + 5)
			fail = 1;
			else fail = 0;
			
		end

		lft_smpl = 1537;
		rght_smpl = 1537;
		//Read data that is wrapping around queue
		repeat (5) @(posedge clk);
		wrt_smpl = 1;
		@(posedge sequencing);
		wrt_smpl = 0;
		@(posedge clk);
		for (i = 0; i < 1021; i = i + 1) begin
			@(posedge clk);
			if(lft_out != i + 6 || rght_out != i + 6)
			fail = 1;
			else fail = 0;
			
		end

		lft_smpl = 1538;
		rght_smpl = 1538;
		//Read data that is wrapping around queue
		repeat (5) @(posedge clk);
		wrt_smpl = 1;
		@(posedge sequencing);
		wrt_smpl = 0;
		@(posedge clk);
		for (i = 0; i < 1021; i = i + 1) begin
			@(posedge clk);
			if(lft_out != i + 7 || rght_out != i + 7)
			fail = 1;
			else fail = 0;
			
		end

		$stop;
	end
	
	// Generate clock signal
	always #1 clk = !clk;	

endmodule

