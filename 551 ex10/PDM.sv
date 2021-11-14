module PDM(clk, rst_n, duty, PDM);

	input clk, rst_n;
	input [14:0]duty;
	output PDM;
	wire update;
	reg [2:0]counter;
	reg [14:0] duty_out;
	wire [14:0] f1, f2, Bin, f2_in;
	reg [14:0] fout;
	

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			counter <= 3'b000;
		end
		else begin
			counter = counter + 1;
		end
	end
	
	assign update = (counter == 3'b111)? 1:0;

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			duty_out <= 15'b0;
			fout <= 15'b0;
		end
		else if (update == 1)begin
			duty_out <= duty;
			fout <= f2;
		end
	end

	assign PDM = (duty_out >= fout)? 1:0;
	assign Bin = (PDM)? 15'h7fff:15'h0;
	assign f1 = Bin - duty_out;
	assign f2 = fout + f1;

endmodule

	
