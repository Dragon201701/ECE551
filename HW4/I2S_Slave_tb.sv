module I2S_Slave_tb();


	logic clk, rst_n, I2S_sclk, I2S_ws, I2S_data;
	logic [23:0] lft_chnnl, rght_chnnl;
	logic [23:0] lft_smpld, rght_smpld;
	logic vld;
	I2S_Slave iDUT(.clk(clk), .rst_n(rst_n), .I2S_sclk(I2S_sclk), .I2S_ws(I2S_ws), .I2S_data(I2S_data), .lft_chnnl(lft_chnnl), .rght_chnnl(rght_chnnl), .vld(vld));
	I2S_Master iI2S_Master(.clk(clk), .rst_n(rst_n), .I2S_sclk(I2S_sclk), .I2S_data(I2S_data), .I2S_ws(I2S_ws));

	always@(posedge clk, negedge rst_n) begin
		if(!rst_n) lft_smpld <= 0;
		else if(vld) lft_smpld <= lft_chnnl;
	end

	always@(posedge clk, negedge rst_n) begin
		if(!rst_n) rght_smpld <= 0;
		else if(vld) rght_smpld <= rght_chnnl;
	end

	initial begin
		clk = 0;
		rst_n = 0;
		@(posedge clk);
		rst_n = 1;
		#(700000);
		$stop();
	end
	
	always #1 clk <= ~clk;
endmodule
