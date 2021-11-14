module FIR_B2_tb ();

	logic clk;    // Clock
	logic rst_n, RST_n;  // Asynchronous reset active low
	logic [15:0] rght_out; // right channel audio output
	logic [15:0] lft_out;  // left channel audio output
	logic RX;
	logic TX;
	logic I2S_sclk, I2S_ws, I2S_data;
	logic cmd_n;
	logic prev_n, next_n;

	logic wrt_smpl;
	logic sequencing;
	logic [15:0] lft_smpl, rght_smpl, lft_in, rght_in;

	rst_synch irst (.clk(clk), .RST_n(RST_n), .rst_n(rst_n));

	RN52 iRN52 (.clk(clk), .RST_n(RST_n), .cmd_n(cmd_n), .RX(RX), .TX(TX),.I2S_sclk(I2S_sclk), .I2S_data(I2S_data), .I2S_ws(I2S_ws));
	I2S_Slave iSlave (.clk(clk), .rst_n(rst_n), .I2S_sclk(I2S_sclk),
					  .I2S_data(I2S_data), .I2S_ws(I2S_ws), 
					  .lft_chnnl(lft_smpl), .rght_chnnl(rght_smpl), 
					  .vld(wrt_smpl));
	high_freq_queue iqueue(.clk(clk), .rst_n(rst_n), .wrt_smpl(wrt_smpl), 
						   .lft_smpl(lft_smpl), .rght_smpl(rght_smpl), 
						   .lft_out(lft_in), .rght_out(rght_in), 
						   .sequencing(sequencing));
	FIR_B2 iB2(.clk(clk), .rst_n(rst_n), .sequencing(sequencing), 
		       .lft_in(lft_in), .rght_in(rght_in), .lft_out(lft_out), 
		       .rght_out(rght_out));
	
	BT_intf iBT(.clk(clk), .rst_n(rst_n), .next_n(next_n), .prev_n(prev_n), .cmd_n(cmd_n), .TX(RX),.RX(TX));

	logic [15:0] left_chnnl, rght_chnnl;
	always_ff @(posedge clk or negedge RST_n) begin : proc_chnnl
		if(wrt_smpl) begin
			left_chnnl <= lft_out;
			rght_chnnl <= rght_out;
		end
	end

	initial begin
		clk = 0;
		RST_n = 0;
		rst_n = 0;
		next_n = 1;
		prev_n = 1;
		@(posedge clk);
		RST_n = 1;
		rst_n = 1;
		@(negedge cmd_n);
		repeat (5000000) @(posedge clk);

//*
		next_n = 0;
		repeat (2000) @(posedge clk);
		next_n = 1;
		repeat (200000) @(posedge clk);
//*/
	
		$stop;
	end

	always
		#1 clk = ~clk;
	
	
endmodule