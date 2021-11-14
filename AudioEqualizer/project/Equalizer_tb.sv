module Equalizer_tb();

reg clk,RST_n;
reg next_n,prev_n;
reg [11:0] LP,B1,B2,B3,HP,VOL;

wire [7:0] LED;
wire ADC_SS_n,ADC_MOSI,ADC_MISO,ADC_SCLK;
wire mic_clk;
wire I2S_data,I2S_ws,I2S_sclk;
wire cmd_n,RX_TX,TX_RX;
wire lft_PDM,rght_PDM;

//////////////////////
// Instantiate DUT //
////////////////////
Equalizer iDUT(.clk(clk),.RST_n(RST_n),.LED(LED),.ADC_SS_n(ADC_SS_n),
                .ADC_MOSI(ADC_MOSI),.ADC_SCLK(ADC_SCLK),.ADC_MISO(ADC_MISO),
                .I2S_data(I2S_data),.I2S_ws(I2S_ws),.I2S_sclk(I2S_sclk),.cmd_n(cmd_n), .sht_dwn(sht_dwn),
				.lft_PDM(lft_PDM),.rght_PDM(rght_PDM),.next_n(next_n),.prev_n(prev_n),
				.RX(RX_TX),.TX(TX_RX));
	
	
//////////////////////////////////////////
// Instantiate model of RN52 BT Module //
/////////////////////////////////////////	
RN52 iRN52(.clk(clk),.RST_n(RST_n),.cmd_n(cmd_n),.RX(TX_RX),.TX(RX_TX),.I2S_sclk(I2S_sclk),
           .I2S_data(I2S_data),.I2S_ws(I2S_ws));

//////////////////////////////////////////////
// Instantiate model of A2D and Slide Pots //
////////////////////////////////////////////		   
A2D_with_Pots iPOTs(.clk(clk),.rst_n(RST_n),.SS_n(ADC_SS_n),.SCLK(ADC_SCLK),.MISO(ADC_MISO),
                    .MOSI(ADC_MOSI),.LP(LP),.B1(B1),.B2(B2),.B3(B3),.HP(HP),.VOL(VOL));
			
initial begin
  
	next_n = 1;
	prev_n = 1;

 	RST_n = 0;
	clk = 0;
	LP = 12'h800;
	B1 = 12'h800;
	B2 = 12'h800;
	B3 = 12'h800;
	HP = 12'h800;
	VOL = 12'h800;
	@(posedge clk);
	@(negedge clk);
	RST_n = 1;
	repeat(4000000)@(posedge clk);
//*
	next_n = 0;
	repeat(2000)@(posedge clk);
	next_n = 1;
	repeat(4000000)@(posedge clk);

	next_n = 0;
	repeat(2000)@(posedge clk);
	next_n = 1;
	repeat(4000000)@(posedge clk);

	prev_n = 0;
	repeat(2000)@(posedge clk);
	prev_n = 1;
	repeat(4000000)@(posedge clk);

	prev_n = 0;
	repeat(2000)@(posedge clk);
	prev_n = 1;
	repeat(4000000)@(posedge clk);
	
//*/
	LP = 12'h800;
	B1 = 12'h000;
	B2 = 12'h000;
	B3 = 12'h000;
	HP = 12'h000;
	VOL = 12'h800;
	repeat(2000000)@(posedge clk);

	LP = 12'h000;
	B1 = 12'h800;
	B2 = 12'h000;
	B3 = 12'h000;
	HP = 12'h000;
	VOL = 12'h800;
	repeat(2000000)@(posedge clk);

	LP = 12'h000;
	B1 = 12'h000;
	B2 = 12'h800;
	B3 = 12'h000;
	HP = 12'h000;
	VOL = 12'h800;
	repeat(2000000)@(posedge clk);

	LP = 12'h000;
	B1 = 12'h000;
	B2 = 12'h000;
	B3 = 12'h800;
	HP = 12'h000;
	VOL = 12'h800;
	repeat(2000000)@(posedge clk);

	LP = 12'h000;
	B1 = 12'h000;
	B2 = 12'h000;
	B3 = 12'h000;
	HP = 12'h800;
	VOL = 12'h800;
	repeat(2000000)@(posedge clk);

	VOL = 12'hF00;
	repeat(2000000)@(posedge clk);

	VOL = 12'h200;
	repeat(2000000)@(posedge clk);
//*/
	$stop();
	
	
  
end

always
  #5 clk = ~ clk;
  
endmodule	  