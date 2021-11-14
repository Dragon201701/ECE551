module EQ_Engine(clk, rst_n, aud_in_lft, aud_in_rght, vld, POT_LP,POT_B1,POT_B2,POT_B3,POT_HP,VOL_POT, aud_out_lft, aud_out_rght);

	input clk, rst_n, vld;
	input [23:0] aud_in_lft, aud_in_rght;
	logic [15:0] lft_smpl, rght_smpl;
	logic vld_low, vld_low_imm, sequencing_high, sequencing_low;
	input [11:0] POT_LP,POT_B1,POT_B2,POT_B3,POT_HP,VOL_POT;
	output logic signed[15:0] aud_out_lft, aud_out_rght;
	logic [15:0] lft_out_high, rght_out_high,lft_out_low,rght_out_low, lft_out_LP, rght_out_LP,lft_out_B1, rght_out_B1,lft_out_B2, rght_out_B2,lft_out_B3, rght_out_B3,lft_out_HP, rght_out_HP;
	logic signed [15:0] band1,band2,band3,band4,band5,band6,band7,band8,band9,band10;
	logic signed [15:0] sum1, sum2;
	logic signed [15:0] sum_flopped1, sum_flopped2;
	logic signed [28:0] prod1, prod2;
	logic signed [28:0] prod_flopped1, prod_flopped2;
	logic signed [12:0] signed_VOL;
	logic signed [15:0] band_flopped1,band_flopped2,band_flopped3,band_flopped4,band_flopped5,band_flopped6,band_flopped7,band_flopped8,band_flopped9,band_flopped10;
	//logic [15:0] lft_out_high_flopped, lft_out_low_flopped, rght_out_high_flopped, rght_out_low_flopped;
	//logic sequencing_high_flopped, sequencing_low_flopped;
	
	assign lft_smpl = aud_in_lft [23:8];
	assign rght_smpl = aud_in_rght [23:8];

	always@(posedge clk, negedge rst_n) begin
		if(!rst_n) vld_low_imm <= 0;
		else if(vld)
			vld_low_imm <= !vld_low_imm;
	end
	assign vld_low = vld & vld_low_imm;


	
	high_freq_queue ihigh_freq(.clk(clk), .rst_n(rst_n), .wrt_smpl(vld), .lft_smpl(lft_smpl), .rght_smpl(rght_smpl), .sequencing(sequencing_high), .lft_out(lft_out_high), .rght_out(rght_out_high));
	low_freq_queue ilow_freq(.clk(clk), .rst_n(rst_n), .wrt_smpl(vld_low), .lft_smpl(lft_smpl), .rght_smpl(rght_smpl), .sequencing(sequencing_low), .lft_out(lft_out_low), .rght_out(rght_out_low));

	/*always@(posedge clk, negedge rst_n) begin
		if(!rst_n) lft_out_high_flopped <= 0;
		else lft_out_high_flopped <= lft_out_high;
	end

	always@(posedge clk, negedge rst_n) begin
		if(!rst_n) lft_out_low_flopped <= 0;
		else lft_out_low_flopped <= lft_out_low;
	end

	always@(posedge clk, negedge rst_n) begin
		if(!rst_n) rght_out_high_flopped <= 0;
		else rght_out_high_flopped <= rght_out_high;
	end

	always@(posedge clk, negedge rst_n) begin
		if(!rst_n) rght_out_low_flopped <= 0;
		else rght_out_low_flopped <= rght_out_low;
	end

	always@(posedge clk, negedge rst_n) begin
		if(!rst_n) sequencing_low_flopped<= 0;
		else sequencing_low_flopped <= sequencing_low;
	end

	always@(posedge clk, negedge rst_n) begin
		if(!rst_n) sequencing_high_flopped <= 0;
		else sequencing_high_flopped <= sequencing_high;
	end*/

	FIR_LP iFIR_LP(.clk(clk), .rst_n(rst_n), .lft_in(lft_out_low), .rght_in(rght_out_low), .sequencing(sequencing_low), .lft_out(lft_out_LP), .rght_out(rght_out_LP));
	FIR_B1 iFIR_B1(.clk(clk), .rst_n(rst_n), .lft_in(lft_out_low), .rght_in(rght_out_low), .sequencing(sequencing_low), .lft_out(lft_out_B1), .rght_out(rght_out_B1));
	FIR_B2 iFIR_B2(.clk(clk), .rst_n(rst_n), .lft_in(lft_out_high), .rght_in(rght_out_high), .sequencing(sequencing_high), .lft_out(lft_out_B2), .rght_out(rght_out_B2));
	FIR_B3 iFIR_B3(.clk(clk), .rst_n(rst_n), .lft_in(lft_out_high), .rght_in(rght_out_high), .sequencing(sequencing_high), .lft_out(lft_out_B3), .rght_out(rght_out_B3));
	FIR_HP iFIR_HP(.clk(clk), .rst_n(rst_n), .lft_in(lft_out_high), .rght_in(rght_out_high), .sequencing(sequencing_high), .lft_out(lft_out_HP), .rght_out(rght_out_HP));

	always@(posedge clk, negedge rst_n) begin
		if(!rst_n) band_flopped1 <= 0;
		else band_flopped1 <= band1;
	end

	always@(posedge clk, negedge rst_n)begin
		if(!rst_n) band_flopped2<= 0;
		else band_flopped2 <= band2;
	end

	always@(posedge clk, negedge rst_n)begin
		if(!rst_n) band_flopped3 <= 0;
		else band_flopped3 <= band3;
	end

	always@(posedge clk, negedge rst_n)begin
		if(!rst_n) band_flopped4 <= 0;
		else band_flopped4 <= band4;
	end

	always@(posedge clk, negedge rst_n)begin
		if(!rst_n) band_flopped5<= 0;
		else band_flopped5 <= band5;
	end

	always@(posedge clk, negedge rst_n)begin
		if(!rst_n) band_flopped6 <= 0;
		else band_flopped6 <= band6;
	end

	always@(posedge clk, negedge rst_n)begin
		if(!rst_n) band_flopped7 <= 0;
		else band_flopped7 <= band7;
	end

	always@(posedge clk, negedge rst_n)begin
		if(!rst_n) band_flopped8<= 0;
		else band_flopped8 <= band8;
	end

	always@(posedge clk, negedge rst_n)begin
		if(!rst_n) band_flopped9 <= 0;
		else band_flopped9 <= band9;
	end

	always@(posedge clk, negedge rst_n)begin
		if(!rst_n) band_flopped10<= 0;
		else band_flopped10<= band10;
	end

	band_scale iB1(.clk(clk), .rst_n(rst_n), .scaled(band1), .POT(POT_LP), .audio(lft_out_LP));
	band_scale iB2(.clk(clk), .rst_n(rst_n), .scaled(band2), .POT(POT_B1), .audio(lft_out_B1));
	band_scale iB3(.clk(clk), .rst_n(rst_n), .scaled(band3), .POT(POT_B2), .audio(lft_out_B2));
	band_scale iB4(.clk(clk), .rst_n(rst_n), .scaled(band4), .POT(POT_B3), .audio(lft_out_B3));
	band_scale iB5(.clk(clk), .rst_n(rst_n), .scaled(band5), .POT(POT_HP), .audio(lft_out_HP));
	band_scale iB6(.clk(clk), .rst_n(rst_n), .scaled(band6), .POT(POT_LP), .audio(rght_out_LP));
	band_scale iB7(.clk(clk), .rst_n(rst_n), .scaled(band7), .POT(POT_B1), .audio(rght_out_B1));
	band_scale iB8(.clk(clk), .rst_n(rst_n), .scaled(band8), .POT(POT_B2), .audio(rght_out_B2));
	band_scale iB9(.clk(clk), .rst_n(rst_n), .scaled(band9), .POT(POT_B3), .audio(rght_out_B3));
	band_scale iB10(.clk(clk), .rst_n(rst_n), .scaled(band10), .POT(POT_HP), .audio(rght_out_HP));
//*
	assign sum1 = band_flopped1+band_flopped2+band_flopped3+band_flopped4+band_flopped5;
	assign sum2 = band_flopped6+band_flopped7+band_flopped8+band_flopped9+band_flopped10;

	always@(posedge clk, negedge rst_n)begin
		if(!rst_n) sum_flopped1<= 0;
		else sum_flopped1<= sum1;
	end

	always@(posedge clk, negedge rst_n)begin
		if(!rst_n) sum_flopped2<= 0;
		else sum_flopped2<= sum2;
	end
//*/
	assign signed_VOL = {1'b0, VOL_POT};

	assign prod1 = sum_flopped1*signed_VOL;
	assign prod2 = sum_flopped2*signed_VOL;

	always@(posedge clk, negedge rst_n)begin
		if(!rst_n) prod_flopped1<= 0;
		else prod_flopped1<= prod1;
	end

	always@(posedge clk, negedge rst_n)begin
		if(!rst_n) prod_flopped2<= 0;
		else prod_flopped2<= prod2;
	end

	assign aud_out_lft = prod_flopped1[27:12];
	assign aud_out_rght = prod_flopped2[27:12];

	
endmodule

