	module SPI_mstr_tb();

		reg clk, rst_n, wrt;
		reg [15:0] wt_data;
		wire [15:0] rd_data;
		wire SCLK, MISO, MOSI, SS_n, done;

		SPI_mstr iDUT(.clk(clk), .rst_n(rst_n), .SS_n(SS_n), .SCLK(SCLK), .MISO(MISO), .MOSI(MOSI), .wrt(wrt), .done(done), .rd_data(rd_data), .wt_data(wt_data));
		ADC128S iADC(.clk(clk),.rst_n(rst_n),.SS_n(SS_n),.SCLK(SCLK),.MISO(MISO),.MOSI(MOSI));
		initial begin
			clk = 0;
			rst_n = 0;
			wrt = 0;
			wt_data = {2'b00, 3'b010, 11'h000};
			@(posedge clk);
			@(negedge clk);
			rst_n = 1;
			@(negedge clk);
			wrt = 1;
			@(negedge clk);
			wrt = 0;
			@(posedge done);
			if (rd_data !== 16'h0C00) begin
				$display("ERR: Expected 0xC00 for first read");
				$stop();
			end

			repeat(2) @(negedge clk);
			wt_data = {2'b00, 3'b010, 11'h000};
			wrt = 1;
			@(negedge clk);
			wrt = 0;
			@(posedge done);
			if (rd_data !== 16'h0C02) begin
				$display("ERR: Expected 0xC02 for first read");
				$stop();
			end

			repeat(2) @(negedge clk);
			wt_data = {2'b00, 3'b011, 11'h000};
			wrt = 1;
			@(negedge clk);
			wrt = 0;
			@(posedge done);
			if (rd_data !== 16'h0BF2) begin
				$display("ERR: Expected 0x0BF2 for first read");
				$stop();
			end
			repeat(2) @(negedge clk);
			wt_data = {2'b00, 3'b011, 11'h000};
			wrt = 1;
			@(negedge clk);
			wrt = 0;
			@(posedge done);
			if (rd_data !== 16'h0BF3) begin
				$display("ERR: Expected 0xC02 for first read");
				$stop();
			end
			repeat(500) @(posedge clk);
			$display("Congratualtion, you pass the test!");
			$stop();
		end
		always
			#1 clk <= ~clk;
	endmodule