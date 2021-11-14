module band_scale(POT, audio, scaled);
	input [11:0] POT;
	input signed [15:0] audio;
	output signed [15:0] scaled;
	
	wire [23:0] POT_squared;
	wire signed [12:0] POT_signed;
	assign POT_squared = POT * POT;
	assign POT_signed = {1'b0, POT_squared[23:12]};
	//wire signed [25:0] saturated; 
	wire signed [28:0] product;
	//wire [2:0] overflow;

	wire neg_flag, pos_flag;

	assign product = POT_signed * audio;
	
	//assign scaled = [25:10] product;
	//assign overflow = [27:25] product;
	
	

	assign neg_flag = (product[28] == 1'b1 && product[27:25]  != 3'b111)? 1'b1 : 1'b0;
	assign pos_flag = (product[28] == 1'b0 && product[27:25]  != 3'b000)? 1'b1 : 1'b0;

	assign scaled = (neg_flag == 1'b1)? 16'b1000000000000000 : 
					(pos_flag == 1'b1)? 16'b0111111111111111 : product[25:10];

	//assign scaled = (neg_flag == 1'b1 && pos_flag == 1'b0)? 16'b1000000000000000 : product[25:10];
	//assign scaled = (pos_flag == 1'b1 && neg_flag == 1'b0)? 16'b0111111111111111 : product[25:10];
	
endmodule
