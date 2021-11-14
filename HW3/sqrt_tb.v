module sqrt_tb();

	reg [15:0] mag;
	reg go, clk, rst_n;
	wire [7:0] sqrt;
	wire done;

	sqrt iDUT(.mag(mag), .go(go), .clk(clk), .rst_n(rst_n), .sqrt(sqrt), .done(done));

	initial begin
		rst_n = 1;
		clk = 0;
		go = 0;
		#1 mag = 16'hffff;
		#1 go = 1;
		#1 go = 0;
		#16 mag = 16'h8000;
		#1 go = 1;
		#1 go = 0;
		#16 mag = 16'h0001;
		#1 go = 1;
		#1 go = 0;
		#16 $stop();
	end

	always
	#1 clk = ~clk;
endmodule