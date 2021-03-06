module slide_intf(clk, rst_n, MISO, SS_n, SCLK, MOSI, POT_LP, POT_B1, POT_B2, POT_B3, POT_HP, VOLUME);

	input clk, rst_n, MISO;
	output logic SS_n, SCLK, MOSI;
	output logic [11:0] POT_LP, POT_B1, POT_B2, POT_B3, POT_HP, VOLUME;
	logic [11:0] res;
	logic strt_cnv, cnv_cmplt;
	logic [2:0] chnnl;


	A2D_intf iA2D_intf(.clk(clk), .rst_n(rst_n), .strt_cnv(strt_cnv), .chnnl(chnnl), .MISO(MISO), .cnv_cmplt(cnv_cmplt), .res(res), .SS_n(SS_n), .SCLK(SCLK), .MOSI(MOSI));
	
	logic chng_chnnl;

	always @(posedge clk, negedge rst_n) begin
		if(!rst_n) chnnl <= 3'b001;
		else if(chng_chnnl) begin
			case(chnnl)
				3'b001: chnnl <= 3'b000;
				3'b000: chnnl <= 3'b100;
				3'b100: chnnl <= 3'b010;
				3'b010: chnnl <= 3'b011;
				3'b011: chnnl <= 3'b111;
				3'b111: chnnl <= 3'b001;
			endcase
		end
	end
	
	typedef enum logic {IDLE, DATA} state_t;
	state_t state, nxt_state;

	always@(posedge clk, negedge rst_n) begin
		if(!rst_n) state <= IDLE;
		else state <= nxt_state;
	end

	always@(*) begin
		strt_cnv = 0;
		chng_chnnl = 0;
		nxt_state = IDLE;
		case(state) 
			IDLE: begin
				strt_cnv = 1;
				//en = chnnl;
				nxt_state = DATA;
			end
			DATA: begin
				if(cnv_cmplt) begin
					chng_chnnl = 1;
					nxt_state =IDLE;
				end
				else nxt_state = DATA;
			end
		endcase
	end

	always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			POT_LP <= 0;
			POT_B1 <= 0;
			POT_B2 <= 0;
			POT_B3 <= 0;
			POT_HP <= 0;
			VOLUME <= 0;
		end
		else if(chng_chnnl) begin
			case(chnnl)
				3'b001: POT_LP <= res;
				3'b000: POT_B1 <= res;
				3'b100: POT_B2 <= res;
				3'b010: POT_B3 <= res;
				3'b011: POT_HP <= res;
				3'b111: VOLUME <= res;
			endcase
		end
	end

endmodule
