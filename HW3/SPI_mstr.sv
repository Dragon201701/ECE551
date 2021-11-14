module SPI_mstr(clk, rst_n, SS_n, SCLK, MOSI, MISO, wrt, wt_data, done, rd_data);
	input logic clk, rst_n, wrt, MISO;
	input [15:0] wt_data;
	output logic done, SS_n, SCLK, MOSI;
	output logic [15:0] rd_data;
	logic shift, init;

	logic ld_SCLK;

	// Bit counter
	//wire [4:0] bitcount;
	logic [4:0] bitcountout;
	wire done16;
	//assign bitcountout = (init == 1)? 5'b00000 :
	//			 		 (shift == 1)? bitcountout + 1 : bitcountout;
	
	

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) 
			bitcountout <= 5'b00000;
		else begin
			if(init == 1)
				bitcountout <= 5'b00000;
			else if(shift == 1) 
				bitcountout <= bitcountout + 1;
			else
				bitcountout <= bitcountout;
		end
	end
	
	logic [3:0] SCLK_div;

	always @(posedge clk or negedge rst_n) begin 
		if(!rst_n)
			SCLK_div = 4'b1011;
		else if(clk) begin
			if(ld_SCLK)
				SCLK_div = 4'b1011;
			else begin
				SCLK_div <= SCLK_div + 1;
			end
		end
	end
	
	assign SCLK = SCLK_div[3];
	assign full = (SCLK_div == 4'b1111)? 1:0;
	assign shift = (SCLK_div == 4'b1001)? 1:0;
	assign done16 = (bitcountout[4] == 1)? 1 : 0;

	logic [15:0] shift_reg;
	always_ff @(posedge clk or negedge rst_n) begin
		if(~rst_n) begin
			shift_reg <= 0;
		end 
		else if(init)
			shift_reg = wt_data;
		else if(shift) begin
			
			shift_reg = {shift_reg[14:0], MISO};
		end
	end
	assign MOSI = shift_reg[15];
	typedef enum reg [2:0] {IDLE, SHIFT, BP} state_t; 
	state_t state, nxt_state;
	logic set_done;

	always_ff @(posedge clk or negedge rst_n) begin
		if(~rst_n) begin
			state = IDLE;
			SS_n = 1;
		end 
		else begin
			state = nxt_state;
			if(init) begin
				SS_n = 0;
			end 
			else if(set_done) begin
				rd_data = shift_reg;
				done = 1;
				SS_n = 1;
			end
			else
				done = 0;
		end
	end
	
	always_comb begin
		nxt_state = IDLE;
		ld_SCLK = 0;
		init = 0;
		set_done = 0;
		case (state)
			IDLE: begin 
				if(~wrt) begin
					ld_SCLK = 1;
					nxt_state = IDLE;
				end
				else begin 
					//done = 0;
					init = 1;
					nxt_state = SHIFT;
				end
			end
			SHIFT: begin 
				//ld_SCLK = 0;
				if(~done16) begin
					nxt_state = SHIFT;
				end
				else begin 
					nxt_state = BP;
				end
			end
			BP : begin 
				if(~full) begin
					nxt_state = BP;
				end
				else begin 
					set_done = 1;
					nxt_state = IDLE;
				end
			end
			default: begin 
				nxt_state = IDLE;
			end
		endcase
	
	end
endmodule