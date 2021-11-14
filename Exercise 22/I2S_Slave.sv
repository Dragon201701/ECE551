module I2S_Slave(clk, rst_n, I2S_sclk, I2S_ws, I2S_data, lft_chnnl, rght_chnnl, vld);

	input logic clk, rst_n, I2S_sclk, I2S_data, I2S_ws;
	output logic [23:0] lft_chnnl, rght_chnnl;
	output logic vld;

	//////////////////////////synch sclk///////////////////////////
	logic sclk_itm1,sclk_itm2,sclk_itm3, sclk_rise;
	always @(posedge clk, negedge rst_n) begin
		if(!rst_n) begin
			sclk_itm1 <= 0;
			sclk_itm2 <= 0;		
			sclk_itm3 <= 0;		
		end
		else begin
			sclk_itm1 <= I2S_sclk;
			sclk_itm2 <= sclk_itm1;
			sclk_itm3 <= sclk_itm2;
		end
	end
	assign sclk_rise = (~sclk_itm3 & sclk_itm2)? 1:0;

	/////////////////////////synch ws/////////////////////////
	logic ws_itm1, ws_itm2, ws_itm3, I2S_ws_fall;
	always @(posedge clk, negedge rst_n) begin
		if(!rst_n) begin
			ws_itm1 <= 1;
			ws_itm2 <= 1;
			ws_itm3 <= 1;
		end
		else begin
			ws_itm1 <= I2S_ws;
			ws_itm2 <= ws_itm1;
			ws_itm3 <= ws_itm2;
		end
	end
	assign I2S_ws_fall = (ws_itm3 & ~ws_itm2)? 1:0; 

	/////////////////////////counter up to 48///////////////////////////
	logic clr_cnt;
	logic [4:0] bit_cntr;
	logic eq22, eq23, eq24;
	always @(posedge clk, negedge rst_n) begin
		if(!rst_n) begin
			bit_cntr <= 5'b00000;
		end
		else begin
			if(clr_cnt) bit_cntr <= 5'b00000;
			else if(sclk_rise) bit_cntr <= bit_cntr + 1;
			else bit_cntr <= bit_cntr;
		end
	end
	assign eq22 = (bit_cntr == 5'b10110)? 1:0;
	assign eq23 = (bit_cntr == 5'b10111)? 1:0;
	assign eq24 = (bit_cntr == 6'b11000)? 1:0;

	/////////////shift register//////////////////////////
	logic [47:0] shft_reg;
	logic [23:0] lft_chnnl_raw, rght_chnnl_raw;
	always@(posedge clk, negedge rst_n) begin
		if(!rst_n) shft_reg <= 48'b0;
		else if(sclk_rise) shft_reg <= {shft_reg[46:0],I2S_data};
		else shft_reg <= shft_reg;
	end
	assign lft_chnnl = shft_reg[47:24];
	assign rght_chnnl= shft_reg[23:0];

	/////////////////////////state machine//////////////////////////
	typedef enum logic[1:0] {SYNC, SKIP, LEFT, RIGHT} state_t;
	state_t state, nxt_state;
	
	always_ff@(posedge clk, negedge rst_n) begin
		if(!rst_n) state <= SYNC;
		else state <= nxt_state;
	end

	always_comb begin
		nxt_state = SYNC;
		vld = 0;
		clr_cnt = 0;
		case(state)
			SYNC: begin
				if(I2S_ws_fall) nxt_state = SKIP;
				else nxt_state = SYNC;
			end
			SKIP: begin
				if(sclk_rise) begin
					clr_cnt = 1;
					nxt_state = LEFT;
				end
				else nxt_state = SKIP;
			end
			LEFT: begin
				if(eq24) begin
					clr_cnt = 1;
					nxt_state = RIGHT;
				end
				else nxt_state = LEFT;
			end
			default: begin
				if((sclk_rise && eq22 && !I2S_ws) || (sclk_rise && eq23 && I2S_ws)) nxt_state = SYNC;
				else if (eq24) begin
					vld = 1;
					clr_cnt = 1;
					nxt_state = LEFT;
				end
				else nxt_state = RIGHT;
			end
		endcase
	end

endmodule
