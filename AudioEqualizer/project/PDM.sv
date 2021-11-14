/////////////////translate the input duty cycle amount into a set of high/low signals that denotes the given duty cycle//////////////
module PDM(clk, rst_n, duty, PDM);

	input clk, rst_n;
	input [15:0]duty;
	output PDM;
	wire update;
	reg counter;
	reg [15:0] duty_out;
	wire [15:0] f1, f2, Bin, f2_in;
	reg [15:0] fout;
	
	////////////update PDM to high or low every 2 clk cycles//////////////////
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			counter <= 1'b0;
		end
		else begin
			counter <= counter + 1;
		end
	end
	assign update = (counter == 1'b1)? 1:0;
	//////////////extra flop that takes in duty[15:0] when update is inserted//////////////////
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			duty_out <= 16'b0;
			fout <= 16'b0;
		end
		else if (update == 1)begin
			duty_out <= duty + 16'h8000;
			fout <= f2;
		end
	end
	assign PDM = (duty_out >= fout)? 1:0;
	assign Bin = (PDM)? 16'hffff:16'h0;
	assign f1 = Bin - duty_out;
	assign f2 = fout + f1;

endmodule

	
