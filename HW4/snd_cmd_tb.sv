module snd_cmd_tb();

	logic clk, rst_n, send, resp_rcvd, initialized, RX, TX;
	logic [4:0] cmd_start;
	logic [3:0] cmd_len;
	snd_cmd iDUT(.clk(clk), .rst_n(rst_n), .cmd_start(cmd_start), .send(send), .cmd_len(cmd_len), .resp_rcvd(resp_rcvd));
	RN52_cmd_model iRN52(.clk(clk),.rst_n(rst_n),.initialized(initialized),.RX(RX),.TX(TX));

	initial begin
		cmd_start = 5'b00000;
		cmd_len = 4'b0110;
		clk = 0;
		rst_n = 0;
		#20;
		rst_n = 1;
		send = 1;
		#20;
		cmd_start = 5'b00110;
		cmd_len = 4'b1010;
		#20;	
		$stop();
	end
	always #1 clk <= ~clk;
endmodule
