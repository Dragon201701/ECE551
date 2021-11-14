module A2D_test(clk,RST_n,nxt_chnnl,LEDs,SS_n,MOSI,MISO,SCLK);

input clk,RST_n;		// 50MHz clock and active low unsynchronized reset from push button
input nxt_chnnl;		// unsynchronized push button.  Advances to convert next chnnl
output [7:0] LEDs;		// upper bits of conversion displayed on LEDs
output SS_n;			// Active low slave select to A2D (part of SPI bus)
output MOSI;			// Master Out Slave In to A2D (part of SPI bus)
input MISO;				// Master In Slave Out from A2D (part of SPI bus)
output SCLK;			// Serial clock of SPI bus


///////////////////////////////////////////////////
// Declare any registers or wires you need here //
/////////////////////////////////////////////////
wire [11:0] res;		// result of A2D conversion
wire btn_release;
wire SS_n,SCLK,MOSI,MISO;
logic strt_cnv;
logic [2:0] chnnl;

/////////////////////////////////////
// Instantiate Reset synchronizer //
///////////////////////////////////
rst_synch iRST(.clk(clk), .RST_n(RST_n), .rst_n(rst_n));


////////////////////////////////
// Instantiate A2D Interface //
//////////////////////////////
A2D_intf iA2D(.clk(clk), .rst_n(rst_n), .strt_cnv(strt_cnv), .cnv_cmplt(), .chnnl(chnnl),
              .res(res), .SS_n(SS_n), .SCLK(SCLK), .MOSI(MOSI), .MISO(MISO));

///////////////////////////////////////////////
// Instantiate push button release detector //
/////////////////////////////////////////////
PB_rise iPB(.clk(clk), .rst_n(rst_n), .PB(nxt_chnnl), .rise(btn_release));
 

///////////////////////////////////////////////////////////////////
// Implement method to increment channel and start a conversion //
// with every release of the nxt_chnnl push button.            //
////////////////////////////////////////////////////////////////
always_ff @(posedge clk, negedge rst_n) begin
	if (!rst_n) begin
		strt_cnv <= 0;
		chnnl <= 3'b0;
	end
	else if(btn_release) begin
		strt_cnv <= 1;
		chnnl <= chnnl + 3'b001;
	end
	else begin
		strt_cnv <= 0;
		chnnl <= chnnl;
	end
end

/// Upper 4-bits of LED are upper 4-bits ///
/// of A2D, lower 3 are count /////////////
assign LEDs = {res[11:8],1'b0,chnnl};

endmodule
    
