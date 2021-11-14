module rst_synch(clk, RST_n, rst_n);

	input logic RST_n, clk;
	output logic rst_n;
	logic interm;
	localparam constant_in = 1'b1;

	always@(negedge clk, negedge RST_n) begin
		if (!RST_n) begin
			interm <= 0;
			rst_n <= 0;
		end
		else begin
			interm <= constant_in;
			rst_n <= interm;		
		end	
	end
endmodule
	
