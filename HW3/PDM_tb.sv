module PDM_tb();
	
	reg clk, rst;
	reg [14:0] duty;
	wire PDM;

	PDM iDUT(.clk(clk), .rst_n(rst), .duty(duty), .PDM(PDM));

	initial begin
		rst = 0;
		clk = 0;
		#1 rst = 1;
		duty = 15'b000000000000001;
		repeat (32786 * 8) @(posedge clk);
		duty = 15'b100000000000000;
		repeat (32786 * 8) @(posedge clk);
		duty = 15'b111111111111111;
		repeat (32786 * 8) @(posedge clk);
		$stop();

	end
	
	always 
		#1 clk=~clk;

endmodule