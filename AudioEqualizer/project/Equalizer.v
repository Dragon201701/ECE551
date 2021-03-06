module Equalizer(clk,RST_n,LED,ADC_SS_n,ADC_MOSI,ADC_SCLK,ADC_MISO,
                 I2S_data,I2S_ws,I2S_sclk,cmd_n,sht_dwn,lft_PDM,
				 rght_PDM,Flt_n,next_n,prev_n,RX,TX);
				  
    	input clk;			// 50MHz CLOCK
	input RST_n;		// unsynched active low reset from push button
	output [7:0] LED;	// Extra credit opportunity, otherwise tie low
	output ADC_SS_n;	// Next 4 are SPI interface to A2D
	output ADC_MOSI;
	output ADC_SCLK;
	input ADC_MISO;
	input I2S_data;		// serial data line from BT audio
	input I2S_ws;		// word select line from BT audio
	input I2S_sclk;		// clock line from BT audio
	output cmd_n;		// hold low to put BT module in command mode
	output reg sht_dwn;	// hold high for 5ms after reset
	output lft_PDM;		// Duty cycle of this drives left speaker
	output rght_PDM;	// Duty cycle of this drives right speaker
	input Flt_n;		// when low Amp(s) had a fault and needs sht_dwn
	input next_n;		// active low to skip to next song
	input prev_n;		// active low to repeat previous song
	input RX;			// UART RX (115200) from BT audio module
	output TX;			// UART TX to BT audio module
		
	///////////////////////////////////////////////////////
	// Declare and needed wires or registers below here //
	/////////////////////////////////////////////////////
	wire rst_n;
	wire [11:0] POT_LP,POT_B1,POT_B2,POT_B3,POT_HP,VOLUME;
	wire vld;
	wire [23:0] lft_chnnl,rght_chnnl;
	wire [15:0] lft_out, rght_out;
	reg [18:0] count_shtdwn;

	/////////////////////////////////////
	// Instantiate Reset synchronizer //
	///////////////////////////////////
	rst_synch irst(.clk(clk), .RST_n(RST_n), .rst_n(rst_n));

	//////////////////////////////////////
	// Instantiate Slide Pot Interface //
	////////////////////////////////////					
	slide_intf islide(.clk(clk), .rst_n(rst_n), .MISO(ADC_MISO), .SS_n(ADC_SS_n), .SCLK(ADC_SCLK), .MOSI(ADC_MOSI), .POT_LP(POT_LP), .POT_B1(POT_B1), .POT_B2(POT_B2), .POT_B3(POT_B3), .POT_HP(POT_HP), .VOLUME(VOLUME));
				  
	//////////////////////////////////////
	// Instantiate BT module interface (evan)	////////////////////////////////////
	BT_intf iBT(.clk(clk), .rst_n(rst_n), .next_n(next_n), .prev_n(prev_n), .cmd_n(cmd_n), .TX(TX), .RX(RX));
					
			
    //////////////////////////////////////
    // Instantiate I2S_Slave interface //
    ////////////////////////////////////
	I2S_Slave iSlave(.clk(clk), .rst_n(rst_n), .I2S_sclk(I2S_sclk), .I2S_ws(I2S_ws), .I2S_data(I2S_data), .lft_chnnl(lft_chnnl), .rght_chnnl(rght_chnnl), .vld(vld));

    //////////////////////////////////////////
    // Instantiate EQ_engine or equivalent(still need) //
    ////////////////////////////////////////
	EQ_Engine iEQ(.clk(clk), .rst_n(rst_n), .aud_in_lft(lft_chnnl), .aud_in_rght(rght_chnnl), .vld(vld), .POT_LP(POT_LP), .POT_B1(POT_B1), .POT_B2(POT_B2), .POT_B3(POT_B3), .POT_HP(POT_HP), 
		.VOL_POT(VOLUME), .aud_out_lft(lft_out), .aud_out_rght(rght_out));

	
	/////////////////////////////////////
	// Instantiate PDM speaker driver //
	///////////////////////////////////
	spkr_drv ispkr(.clk(clk), .rst_n(rst_n), .lft_chnnl(lft_out), .rght_chnnl(rght_out), .vld(vld), .lft_PDM(lft_PDM), .rght_PDM(rght_PDM));

	LED_drv iLED(.clk(clk), .rst_n(rst_n), .vld(vld), .aud_out_lft(lft_out), .aud_out_rght(rght_out), .lft_PDM(lft_PDM), .rght_PDM(rght_PDM), .LED(LED));
	
	///////////////////////////////////////////////////////////////
	// Infer sht_dwn/Flt_n logic or incorporate into other unit //
	/////////////////////////////////////////////////////////////
	always@(posedge clk, negedge rst_n) begin
		if (!rst_n) count_shtdwn <= 0;
		else if (!Flt_n) count_shtdwn <=0;
		else if(count_shtdwn != 250000) count_shtdwn <= count_shtdwn+1;
	end

	always @(posedge clk) begin
		if(count_shtdwn == 0) sht_dwn <= 1;
		else if (count_shtdwn == 250000) sht_dwn <= 0;
	end
	
	/*always@(posedge clk, negedge rst_n) begin
		if(!rst_n) LED <= 0;
		else if (vld) LED <= lft_out[14:7] + rght_out[14:7];
	end*/


endmodule
