module up_dwn_cnt4(clk, rst_n, en, dwn, cnt);

	input logic clk, rst_n, en, dwn;
	output logic [3:0] cnt;

	always_ff@(posedge clk, negedge rst_n) begin
		if(!rst_n) cnt <= 4'b0000;
		else if(en) begin
			if(dwn) cnt <= cnt-1;
			else cnt <= cnt+1;
		end
	end
endmodule
