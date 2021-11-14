module snd_cmd(clk, rst_n, cmd_start, send, cmd_len, resp_rcvd);

	input logic clk, rst_n, send;
	input logic [4:0] cmd_start;
	input logic [3:0] cmd_len;
	output logic  resp_rcvd;
	logic [4:0] addr;
	logic [7:0] dout;
	logic RX, trmt, clr_rx_rdy,TX,rx_rdy,tx_done;
	logic [7:0] tx_data, rx_data;
	logic [4:0] sum;
	logic last_byte;
	logic inc_addr;

	UART iUART(.clk(clk),.rst_n(rst_n),.RX(RX),.TX(TX),.rx_rdy(rx_rdy),.clr_rx_rdy(clr_rx_rdy),.rx_data(rx_data),.trmt(trmt),.tx_data(tx_data),.tx_done(tx_done));
	cmdROM icmdROM(.clk(clk),.addr(addr),.dout(dout));

	always@(posedge clk, negedge rst_n) begin
		if(!rst_n) addr <= 0;
		else if (send) addr <= cmd_start;
		else begin
			if(inc_addr) addr = addr +1;
			else addr = addr;
		end
	end

	always@(posedge clk, negedge rst_n) begin
		if(!rst_n) sum <= 0;
		else if(send) sum <= cmd_start+cmd_len;
		else sum <= sum;
	end
	assign last_byte = (addr == sum)? 1:0;
	
	typedef enum reg [1:0] {IDLE, SENDING, RECEIVING} state_t;
	state_t state, nxt_state;
	always_ff@(posedge clk, negedge rst_n) begin
		if(!rst_n) state <= IDLE;
		else state <= nxt_state;
	end

	always_comb begin
		nxt_state = IDLE;
		inc_addr = 0;
		case(state)
			IDLE: begin
				if(send) nxt_state = SENDING;
				else nxt_state = IDLE;
			end
			SENDING: begin
				if(trmt) nxt_state = RECEIVING;
				else nxt_state = SENDING;
			end
			default: begin
				if(last_byte) nxt_state = IDLE;
				else if(tx_done) begin
					inc_addr = 1;
					nxt_state = SENDING;
				end
				else nxt_state = RECEIVING;			
			end
		endcase
	end
	assign resp_rcvd = (rx_rdy && (rx_data == 8'h0A))? 1:0;

	
endmodule
