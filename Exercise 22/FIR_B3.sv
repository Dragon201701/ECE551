module FIR_B3(clk, rst_n, sequencing, lft_in, rght_in, lft_out, rght_out);
  input logic clk, rst_n, sequencing;
  input logic signed [15:0] lft_in, rght_in;
  output logic signed [15:0] lft_out, rght_out;

  // Instantiate ROM module
  logic signed [15:0] ROM_dout;
  ROM_B3 romB3(.clk(clk), .addr(ROM_addr_flop), .dout(ROM_dout));

  // Setup the ROM's module's address input flop
  logic [9:0] ROM_addr_flop;
  always @(posedge clk, negedge rst_n) begin
    if (~rst_n) 
      ROM_addr_flop <= 10'b0;
    else if (rst_addr)
      ROM_addr_flop <= 10'b0;
    else if (inc_addr)
      ROM_addr_flop <= ROM_addr_flop + 1;
  end

  // Perform signed multipication of inputs and ROM output
  logic signed [31:0] lft_mult_result, rght_mult_result;
  assign lft_mult_result = ROM_dout * lft_in;
  assign rght_mult_result = ROM_dout * rght_in;

  // Setup output flops
  logic signed [31:0] lft_full_out, rght_full_out;
  always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
      lft_full_out <= 32'b0;
      rght_full_out <= 32'b0;
    end 
    else if (rst_out) begin
      lft_full_out <= 32'b0;
      rght_full_out <= 32'b0;
    end
    else if (add) begin
      lft_full_out <= lft_full_out + lft_mult_result;
      rght_full_out <= rght_full_out + rght_mult_result;
    end
  end

  // Trim to 16-bit outputs
  assign lft_out = lft_full_out[30:15];
  assign rght_out = rght_full_out[30:15];

  // State machine
  typedef enum logic { INIT, INC } state_t;
  state_t state, nxt_state;

  // Setup flop to hold current state
  always @(posedge clk, negedge rst_n) begin
    if (~rst_n)
      state <= INIT;
    else
      state <= nxt_state;
  end

  always @(*) begin
    rst_addr = 1;       // Reset ROM input addr by default
    rst_out = 1;        // Reset MAC flops by default
    inc_addr = 0;       // Do not increment ROM input addr by default
    add = 0;            // Do not MAC by default
    nxt_state = INIT;   // Default to init state

    case(state)
      INIT:
        // Only leave the initial state when sequencing goes high 
        if (sequencing) begin
          nxt_state = INC;
        end

      default: // Default case represenet state 'INC'
        begin
          // Always increment ROM addr and MAC in this state
          inc_addr = 1;
          add = 1;
          
          if (!sequencing)
            nxt_state = INIT;
         else
            nxt_state = INC;
        end
    endcase
  end

endmodule
