module sqrt(mag, go, clk, rst_n, sqrt, done);
	input go, clk, rst_n;
	input [15:0] mag;
	output logic done;
	output logic [7:0] sqrt;
	logic enable;
	logic [7:0] count;
	typedef enum reg [3:0] {IDLE, SEVENTH, SIXTH, FIFTH, FORTH, THIRD, SECOND, FIRST, ZEROTH} state_t; 
	state_t state, nxt_state;
	logic [7:0] result;
	logic [15:0] square;



	always_ff @(posedge clk or negedge rst_n) begin
		if(~rst_n) begin
			 state <= IDLE;
		end else begin
			 state <= nxt_state;
		end
	end

	always_comb begin
		
		//count = 8'b10000000;
		//nxt_state = SEVENTH;
		//done = 0;
		//nxt_state = IDLE;
		sqrt = 8'b00000000;
		case(state) 
			IDLE: begin 
				done = 0;
				sqrt = 8'b00000000;
				result = 8'b00000000;
				square = 16'b00000000;
				done = 0;
				if(~go) begin
					nxt_state = IDLE;
					$display("Stay in IDLE State");
				end
				else
					nxt_state = SEVENTH;
			end
			SEVENTH: begin
				count = 8'b10000000;
				$display("SEVENTH init: %b",result);
				$display("SEVENTH count: %b",count);
				square = (result+count) * (result+count);
				$display("SEVENTH calculation: %b mag: %h",square, mag);
				if(square <= mag)
					result = result + count;
				else
					result = result;
				nxt_state = SIXTH;
				$display("SEVENTH result: %b\n",result);
			end
			SIXTH: begin
				count = 8'b01000000;
				$display("SIXTH init: %b",result);
				$display("SIXTH count: %b",count);
				square = (result+count) * (result+count);
				$display("SIXTH calculation: %b mag: %h",square, mag);
				if(square <= mag)
					result = result + count;
				else
					result = result;
				nxt_state = FIFTH;
				$display("SIXTH result: %b\n",result);
			end
			FIFTH: begin
				count = 8'b00100000;
				square = (result+count) * (result+count);
				$display("FIFTH init: %b",result);
				$display("FIFTH count: %b",count);
				$display("FIFTH calculation: %b mag: %h",square, mag);
				if(square <= mag)
					result = result + count;
				else
					result = result;
				nxt_state = FORTH;
				$display("FIFTH result: %b\n",result);
			end
			FORTH: begin
				count = 8'b00010000;
				square = (result+count) * (result+count);
				if(square <= mag)
					result = result + count;
				else
					result = result;
				nxt_state = THIRD;
			end
			THIRD: begin
				count = 8'b00001000;
				square = (result+count) * (result+count);
				if(square <= mag)
					result = result + count;
				else
					result = result;
				nxt_state = SECOND;
			end
			SECOND: begin
				count = 8'b00000100;
				square = (result+count) * (result+count);
				if(square <= mag)
					result = result + count;
				else
					result = result;
				nxt_state = FIRST;
			end
			FIRST: begin
				count = 8'b00000010;
				square = (result+count) * (result+count);
				if(square <= mag)
					result = result + count;
				else
					result = result;
				nxt_state = ZEROTH;
			end
			ZEROTH: begin
				count = 8'b00000001;
				square = (result+count) * (result+count);
				if(square <= mag)
					result = result + count;
				else
					result = result;
				sqrt = result;
				done = 1;
				nxt_state = IDLE;
			end
			default begin 
				nxt_state = IDLE;
			end
		endcase // state
	end
endmodule