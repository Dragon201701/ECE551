module BT_intf(clk, rst_n, next_n, prev_n, cmd_n, TX, RX);

	input clk, rst_n, next_n, prev_n, RX;

	output reg cmd_n;
	output TX;

	logic next, prev, send;
	logic [4:0] cmd_start;
	logic [3:0] cmd_len;
	logic resp_rcvd;

	logic [16:0] timer;

	PB_rise BUT1(.PB(next_n), .clk(clk), .rst_n(rst_n), .rise(next));
	PB_rise BUT2(.PB(prev_n), .clk(clk), .rst_n(rst_n), .rise(prev));

	snd_cmd SC(.clk(clk), .rst_n(rst_n), .cmd_len(cmd_len), .send(send),
	 .cmd_start(cmd_start), .resp_rcvd(resp_rcvd), .TX(TX), .RX(RX));

  	typedef enum logic [2:0] {Wait, Check, Start, Name ,Idle, Next, Prev} state_t;
  	state_t state, nxt_state;

	always @(posedge clk, negedge rst_n) begin
		if(!rst_n) begin
			timer <= 17'h00000;
		end
		else begin
			timer <= timer + 1;
		end
	end

//state machine stuff
	always @(posedge clk, negedge rst_n) begin
		if (~rst_n)
      			state <= Wait;
    		else
      			state <= nxt_state;
	end

	always @(*) begin
		send = 0;
		cmd_n = 0;
		cmd_start = 5'b00000;
		cmd_len = 4'b0110;
		case(state)
			Wait: begin
				cmd_n = 1;
				if(timer == 17'h1FFFF)
					nxt_state = Check;
				else
					nxt_state = Wait;
			end

			Check: begin
				if(resp_rcvd) begin
					nxt_state = Start;
					send = 1;
				end
				else
					nxt_state = Check;
			end

			Start: begin
				if(resp_rcvd) begin
					nxt_state = Name;
					cmd_start = 5'b00110;
					cmd_len = 4'b1010;
					send = 1;
				end
				else
					nxt_state = Start;
			end

			Name: begin
				if(resp_rcvd) begin
					nxt_state = Idle;
				end
				else
					nxt_state = Name;
			end

			Idle: begin
				if(next) begin
					nxt_state = Next;
					cmd_start = 5'b10000;
					cmd_len = 4'b0100;
					send = 1;
				end
				else if(prev) begin
					nxt_state = Prev;
					cmd_start = 5'b10100;
					cmd_len = 4'b0100;
					send = 1;
				end
				else
					nxt_state = Idle;
			end

			Next: begin
				if(resp_rcvd) begin
					nxt_state = Idle;
				end
				else
					nxt_state = Next;
			end

			Prev: begin
				if(resp_rcvd) begin
					nxt_state = Idle;
				end
				else
					nxt_state = Prev;
			end
		endcase
	end

endmodule
