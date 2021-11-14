module BT_intf_tb();

reg clk, rst_n, next_n, prev_n;

wire cmd_n, TX, RX, I2S_sclk, I2S_ws, I2S_data, vld;
logic [23:0] lft_chnnl, rght_chnnl, lft_smpld, rght_smpld;

BT_intf iDUT(.clk(clk), .rst_n(rst_n), .next_n(next_n), .prev_n(prev_n),
 .cmd_n(cmd_n), .TX(TX), .RX(RX));

RN52 nDUT(.clk(clk),.RST_n(rst_n),.cmd_n(cmd_n),.RX(TX),.TX(RX),
 .I2S_sclk(I2S_sclk),.I2S_data(I2S_data),.I2S_ws(I2S_ws));

I2S_Slave sDUT(.clk(clk), .rst_n(rst_n), .I2S_sclk(I2S_sclk), 
 .I2S_ws(I2S_ws), .I2S_data(I2S_data), .lft_chnnl(lft_chnnl), 
 .rght_chnnl(rght_chnnl), .vld(vld));

initial begin
	clk = 0;
	rst_n = 0;
	next_n = 1;
	prev_n = 1;
	@(posedge clk);
	rst_n = 1;
	@(negedge cmd_n);
	repeat (200000) @(posedge clk);
	next_n = 0;
	repeat (2000) @(posedge clk);
	next_n = 1;
	repeat (200000) @(posedge clk);

	next_n = 0;
	repeat (2000) @(posedge clk);
	next_n = 1;
	repeat (200000) @(posedge clk);

	prev_n = 0;
	repeat (2000) @(posedge clk);
	prev_n = 1;
	repeat (200000) @(posedge clk);

	$stop;
end

always @(posedge clk) begin
	//Update the left and right samples only when valid
	if(vld) begin
		lft_smpld = lft_chnnl;
		rght_smpld = rght_chnnl;
	end
end

always
	#1 clk = ~clk;

endmodule
