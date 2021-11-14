module A2D_intf(clk, rst_n, strt_cnv, chnnl, MISO, cnv_cmplt, res, SS_n, SCLK, MOSI);

	input logic clk, rst_n, strt_cnv, MISO;
	input logic [2:0] chnnl;
	output logic cnv_cmplt, SS_n, SCLK, MOSI;
	output logic [11:0] res;
	logic [15:0] cmd;
	logic set_cnv_cmplt;
	logic [15:0] rd_data;
	logic wrt;

	SPI_mstr SPI_mstr(.clk(clk), .rst_n(rst_n), .SS_n(SS_n), .SCLK(SCLK), .MOSI(MOSI), .MISO(MISO), .wrt(wrt), .wt_data(cmd), .done(done), .rd_data(rd_data));

	assign cmd = {2'b00, chnnl, 11'b0};
	assign res = rd_data[11:0];

	typedef enum reg[1:0] {IDLE, TRANS, WAIT, READ} state_t;
	state_t state, next_state;

	always_ff@(posedge clk, negedge rst_n) begin
		if(!rst_n) state <= IDLE;
		else state <= next_state;
	end

	always_comb begin
		next_state = IDLE;
		wrt = 0;
		set_cnv_cmplt = 0;
		case(state)
			IDLE: begin
				if(strt_cnv) begin
					wrt = 1;
					next_state = TRANS;
				end
				else next_state = IDLE;
			end
			TRANS: begin 
				if(done) next_state = WAIT;
				else next_state = TRANS;
			end
			WAIT: begin
				wrt = 1;
				next_state = READ;
			end
			READ: begin
				if(done) begin
					set_cnv_cmplt = 1;
					next_state = IDLE;
				end 
				else next_state = READ;
			end
			default: next_state = IDLE;
		endcase
	end			

	always_ff@(posedge clk, negedge rst_n) begin
		if(!rst_n) cnv_cmplt <= 0;
		else if(strt_cnv) cnv_cmplt <= 0;
		else cnv_cmplt <= set_cnv_cmplt;
	end
endmodule
