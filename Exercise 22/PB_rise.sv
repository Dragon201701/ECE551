module PB_rise(PB, clk, rst_n, rise);

	input logic PB, clk, rst_n;
	output logic rise;
	logic ff1, ff2, ff3;

	always@(posedge clk, negedge rst_n) begin
		if (!rst_n) begin
			ff1 <= 0;
			ff2 <= 0;
			ff3 <= 0;
		end
		else begin
			ff1 <= PB;
			ff2 <= ff1;
			ff3 <= ~ff2;
		end
	end
	assign rise = (ff3 & ff2)? 1:0;
endmodule
