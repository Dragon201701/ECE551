module band_scale(clk, rst_n, scaled, POT, audio);

	input clk, rst_n;
	input [11:0] POT;
	reg [11:0] POT_flopped;
	input signed [15:0] audio;
	output signed [15:0] scaled;
	wire [23:0] POT_squared;
	reg [23:0] POT_squared_flopped;
	wire signed [12:0] POT_signed;
	wire signed [28:0] mult;
	wire pos_flag;
	wire neg_flag;

	always@(posedge clk, negedge rst_n) begin
		if(!rst_n) POT_flopped <= 0;
		else POT_flopped <= POT;
	end

	always@(posedge clk, negedge rst_n) begin
		if(!rst_n) POT_squared_flopped <= 0;
		else POT_squared_flopped <= POT_squared;
	end

	assign POT_squared = POT_flopped*POT_flopped;
	assign POT_signed = {1'b0, POT_squared_flopped[23:12]};
	assign mult = POT_signed*audio;
	assign neg_flag = (mult[28]==1'b1 && mult[27:25] != 3'b111)? 1'b1:1'b0;
	assign pos_flag = (mult[28]==1'b0 && mult[27:25] != 3'b000)? 1'b1:1'b0;
	assign scaled = (neg_flag==1)? 16'b1000000000000000: 
	                (pos_flag==1)? 16'b0111111111111111:
                         mult[25:10];
endmodule
