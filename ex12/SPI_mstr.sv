/////////////block that reads from slave and output to slave at the same time/////////////////
module SPI_mstr(clk, rst_n, SS_n, SCLK, MOSI, MISO, wrt, wt_data, done, rd_data);
	input logic clk, rst_n, wrt, MISO;
	input [15:0] wt_data;
	output logic done, SS_n, SCLK, MOSI;
	output logic [15:0] rd_data;
	logic shift, init;
	logic ld_SCLK;
	logic [4:0] bitcountout;
	wire done16;
////////////counts that if all 16 bits shift have been done////////////
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
	assign done16 = (bitcountout[4] == 1)? 1 : 0;
/////////MSB becomes SCLK, shift starts 2 clks after SCLK becomes 1 ////////////
	logic [3:0] SCLK_div;
	always @(posedge clk or negedge rst_n) begin 
		if(!rst_n)
			SCLK_div = 4'b1011;
		else if(ld_SCLK)
			SCLK_div = 4'b1011;
		else
			SCLK_div <= SCLK_div + 1;
	end
	assign SCLK = SCLK_div[3];
	assign full = (SCLK_div == 4'b1110)? 1:0;//used later in back porch state
	assign shift = (SCLK_div == 4'b1001)? 1:0;
//////////shift register which stores MOSI, then reads in MISO 1 bit at a time till all 16 bits are replaced with MISO////////////
	logic [15:0] shift_reg;
	always_ff @(posedge clk or negedge rst_n) begin
		if(~rst_n) begin
			shift_reg <= 0;
		end 
		else if(init)
			shift_reg = wt_data;
		else if(shift) begin
			shift_reg = {shift_reg[14:0], MISO};//1 bit in
		end
	end
	assign MOSI = shift_reg[15];//1 bit out
//////////state machine that constitutes this block///////////////
	typedef enum reg [2:0] {IDLE, SHIFT, BackPorch} state_t; 
	state_t state, nxt_state;
	logic set_done;
	always_ff @(posedge clk or negedge rst_n) begin
		if(~rst_n) begin
			state = IDLE;
			SS_n = 1;//toggle slave select
		end 
		else begin
			state = nxt_state;
			if(init) begin
				SS_n = 0;
			end 
			else if(set_done) begin
				//rd_data = shift_reg;  after all 16 bits are shifted, read data in shift register, which should be replaced by MISO
				done = 1;
				SS_n = 1;
			end
			else
				done = 0;
		end
	end
	assign rd_data = shift_reg;
////////////use 3 cases to denote 3 states//////////////
	always_comb begin
		nxt_state = IDLE;
		ld_SCLK = 0;
		init = 0;
		set_done = 0;
		case (state)
			IDLE: begin 
				if(wrt) begin
					init = 1;
					nxt_state = SHIFT;
				end
				else begin 
					ld_SCLK = 1;
					nxt_state = IDLE;
				end
			end
			SHIFT: begin 
				if(done16) begin
					nxt_state = BackPorch;
				end
				else begin 
					nxt_state = SHIFT;
				end
			end
			BackPorch : begin 
				if(full) begin//gives some extra time before SS_n goes high
					set_done = 1;
					nxt_state = IDLE;
				end
				else begin 
					nxt_state = BackPorch;
				end
			end
			default: begin 
				nxt_state = IDLE;
			end
		endcase
	
	end
endmodule

