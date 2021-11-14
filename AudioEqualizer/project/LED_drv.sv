module LED_drv (clk, rst_n, vld, aud_out_lft, aud_out_rght, lft_PDM, rght_PDM, LED);
	input clk, rst_n, vld;
	input [15:0] aud_out_lft, aud_out_rght;
	input lft_PDM, rght_PDM;
	output logic [7:0] LED;
	logic [3:0] rght_vld, lft_vld;
	logic [3:0] rght_LED, lft_LED;
	always_ff @(posedge clk or negedge rst_n) begin : proc_rght_vld
		if(~rst_n) begin
			rght_vld <= 0;
		end else if(vld) begin
			if(aud_out_rght >= 0)
				rght_vld[0] <= 1;
			else
				rght_vld[0] <= 0;

			if(aud_out_rght >= 16'h10)
				rght_vld[1] <= 1;
			else
				rght_vld[1] <= 0;

			if(aud_out_rght >= 16'h100)
				rght_vld[2] <= 1;
			else
				rght_vld[2] <= 0;

			if(aud_out_rght >= 16'h1000)
				rght_vld[3] <= 1;
			else
				rght_vld[3] <= 0;
		end
	end
	always_ff @(posedge clk or negedge rst_n) begin : proc_lft_vld
		if(~rst_n) begin
			lft_vld <= 0;
		end else if(vld) begin
			if(aud_out_lft >= 0)
				lft_vld[3] <= 1;
			else
				lft_vld[3] <= 0;

			if(aud_out_lft >= 16'h10)
				lft_vld[2] <= 1;
			else
				lft_vld[2] <= 0;

			if(aud_out_lft >= 16'h100)
				lft_vld[1] <= 1;
			else
				lft_vld[1] <= 0;

			if(aud_out_lft >= 16'h1000)
				lft_vld[0] <= 1;
			else
				lft_vld[0] <= 0;
		end
	end
	always_ff @(posedge clk or negedge rst_n) begin : proc_LED
		if(~rst_n) begin
			lft_LED <= 0;
			rght_LED <= 0;
		end else begin
			if(rght_vld[0])
				rght_LED[0] <= rght_PDM;
			else
				rght_LED[0] <= 0;
			if(rght_vld[1])
				rght_LED[1] <= rght_PDM;
			else
				rght_LED[1] <= 0;
			if(rght_vld[2])
				rght_LED[2] <= rght_PDM;
			else
				rght_LED[2] <= 0;
			if(rght_vld[3])
				rght_LED[3] <= rght_PDM;
			else
				rght_LED[3] <= 0;
			if(lft_vld[0])
				lft_LED[0] <= lft_PDM;
			else
				lft_LED[0] <= 0;
			if(lft_vld[1])
				lft_LED[1] <= lft_PDM;
			else
				lft_LED[1] <= 0;
			if(lft_vld[2])
				lft_LED[2] <= lft_PDM;
			else
				lft_LED[2] <= 0;
			if(lft_vld[3])
				lft_LED[3] <= lft_PDM;
			else
				lft_LED[3] <= 0;
		end
	end
	assign LED = {rght_LED, lft_LED};

endmodule