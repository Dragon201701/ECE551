module snd_cmd(clk, rst_n, cmd_start, send, cmd_len, resp_rcvd, RX, TX);

	input logic clk, rst_n, send,RX;
	input logic [4:0] cmd_start;
	input logic [3:0] cmd_len;
	output logic  resp_rcvd,TX;
	logic [4:0] addr;
	logic [7:0] dout;
	logic trmt, clr_rx_rdy,rx_rdy,tx_done;
	logic [7:0] tx_data, rx_data;
	logic [4:0] sum;
	logic last_byte;
	logic inc_addr;

	UART iUART(.clk(clk),.rst_n(rst_n),.RX(RX),.TX(TX),.rx_rdy(rx_rdy),.clr_rx_rdy(rx_rdy),.rx_data(rx_data),.trmt(trmt),.tx_data(dout),.tx_done(tx_done));
	cmdROM icmdROM(.clk(clk),.addr(addr),.dout(dout));

	//////////////////////address increment or new address/////////////////////////
	always@(posedge clk, negedge rst_n) begin
		if(!rst_n) addr <= 0;
		else if (send) addr <= cmd_start;
		else begin
			if(inc_addr) addr <= addr +1;
			else addr <= addr;
		end
	end

	//////////////////////decide if last byte is reached/////////////////////////
	always@(posedge clk, negedge rst_n) begin
		if(!rst_n) sum <= 0;
		else if(send) sum <= cmd_start+cmd_len;
		else sum <= sum;
	end
	assign last_byte = (addr == sum)? 1:0;
	
	////////////////////state machine//////////////////////////
	typedef enum reg [1:0] {IDLE, WAIT1, WAIT2, DATA} state_t;
	state_t state, nxt_state;
	always_ff@(posedge clk, negedge rst_n) begin
		if(!rst_n) state <= IDLE;
		else state <= nxt_state;
	end

	always_comb begin
		nxt_state =  IDLE;
		inc_addr = 0;
		trmt = 0;
		case(state)
			IDLE: begin
				if(send) nxt_state = WAIT1;
				else nxt_state = IDLE;
			end
			WAIT1: begin
				nxt_state = WAIT2;
			end
			WAIT2: begin
				trmt = 1;
				inc_addr = 1;
				nxt_state = DATA;
			end
			DATA: begin
				if(!last_byte && tx_done) begin
					trmt = 1;
					inc_addr = 1;	
					nxt_state = DATA;
				end
				else if(last_byte && tx_done) begin
					trmt = 1;
					nxt_state = IDLE;
				end
				else nxt_state = DATA;
			end
		endcase
	end
	assign resp_rcvd = (rx_rdy && (rx_data == 8'h0A))? 1:0;

	
endmodule
