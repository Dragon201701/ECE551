module spkr_drv(clk, rst_n, lft_chnnl, rght_chnnl, vld, lft_PDM, rght_PDM);

	input logic [15:0] lft_chnnl, rght_chnnl;
	input clk, rst_n, vld;
	output lft_PDM, rght_PDM;
	logic [15:0] lft_duty, rght_duty;

	PDM iPDM1ft(.clk(clk), .rst_n(rst_n), .duty(lft_duty), .PDM(lft_PDM));
	PDM iPDMrght(.clk(clk), .rst_n(rst_n), .duty(rght_duty), .PDM(rght_PDM));

	always@(posedge clk, negedge rst_n) begin
		if(!rst_n) lft_duty <= 0;
		else if(vld) lft_duty <= lft_chnnl;
		else lft_duty <= lft_duty;
	end

	always@(posedge clk, negedge rst_n) begin
		if(!rst_n) rght_duty <= 0;
		else if(vld) rght_duty <= rght_chnnl;
		else rght_duty <= rght_duty;
	end
endmodule	
