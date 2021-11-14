module low_freq_queue(clk, rst_n, wrt_smpl, lft_smpl, rght_smpl, sequencing, lft_out, rght_out);

	input logic clk, rst_n, wrt_smpl;
	input logic [15:0] lft_smpl, rght_smpl;

	output logic [15:0] lft_out, rght_out;
	output logic sequencing;

	logic [9:0] new_ptr, read_ptr, old_ptr;
	wire [10:0] ideal_end_ptr, wrapped_end_ptr;
	wire [9:0] end_ptr;

// Left queue memory model
	dualPort1024x16 lMem(.clk(clk), .wdata(lft_smpl), .waddr(new_ptr), .we(wrt_smpl), .rdata(lft_out), .raddr(read_ptr));

// Right queue memory model
	dualPort1024x16 rMem(.clk(clk), .wdata(rght_smpl), .waddr(new_ptr), .we(wrt_smpl), .rdata(rght_out), .raddr(read_ptr));

// State machine
	typedef enum logic[1:0] {VACANCY, FULL, READ} state_t;
	state_t state, nxt_state;

	always @(posedge clk, negedge rst_n) begin
		if (~rst_n) state <= VACANCY;
		else state <= nxt_state;
	end

	assign ideal_end_ptr = old_ptr + 11'd1020;
	assign wrapped_end_ptr = old_ptr + 11'd1020 - 11'd1024;
	assign end_ptr = (ideal_end_ptr>1024) ? wrapped_end_ptr[9:0] : ideal_end_ptr[9:0];
	
	logic queuefull, incRead, initRead;

	always @(*) begin
		nxt_state = VACANCY;
		sequencing = 0;
		initRead = 0;
		incRead = 0;
		case (state)
			VACANCY: begin
				if (new_ptr == 10'd1021) begin
					nxt_state = FULL;	
				end
			end
		
			FULL: begin
				if (wrt_smpl) begin
					nxt_state = READ;
					initRead = 1;
					//read_ptr = old_ptr - 1;
				end
				else 
					nxt_state = FULL;
			end	

			READ: begin
				sequencing = 1;
				
				//read_ptr = read_ptr + 1;
				//if (read_ptr > 11'd1535) read_ptr = 11'b0;
				
				if (read_ptr == end_ptr) nxt_state = FULL;
				else begin
					nxt_state = READ;
					incRead = 1;
				end
			end
		endcase
	end

	always @(posedge clk, negedge rst_n) begin
		if (~rst_n)
			read_ptr <= 0;
		else if (initRead)
			read_ptr <= old_ptr /*- 1*/;
		else if (incRead) begin
			if (read_ptr == 10'd1023)
				read_ptr <= 0;
			else
				read_ptr <= read_ptr + 1;
		end
	end
	
	// New pointer flop and wrap around increment logic
	always @(posedge clk, negedge rst_n) begin
		if(!rst_n) begin
			new_ptr <= 0;
		end
		else if (wrt_smpl) begin
		    if (new_ptr==10'd1023)
			  new_ptr <= 10'b0;
			else
			  new_ptr <= new_ptr + 1;
		end
	end

	always @(posedge clk, negedge rst_n)
	  if (!rst_n)
	    queuefull <= 0;
	  else if (new_ptr==10'd1021)
	    queuefull <= 1;
		
		
	// Old & read pointer flops and increment logic
	always @(posedge clk, negedge rst_n) begin
		if(!rst_n) begin
			old_ptr <= 0;
		end
		else if(wrt_smpl && queuefull) begin
		    if (old_ptr==10'd1023)
			  old_ptr <= 10'b0;
			else
			  old_ptr <= old_ptr + 1;
		end	
	end

endmodule

