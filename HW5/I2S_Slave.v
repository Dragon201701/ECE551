/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : N-2017.09-SP5
// Date      : Wed Apr 17 14:04:25 2019
/////////////////////////////////////////////////////////////

`timescale 1ns/1ps
module I2S_Slave ( clk, rst_n, I2S_sclk, I2S_ws, I2S_data, lft_chnnl, 
        rght_chnnl, vld );
  output [23:0] lft_chnnl;
  output [23:0] rght_chnnl;
  input clk, rst_n, I2S_sclk, I2S_ws, I2S_data;
  output vld;
  wire   n134, sclk_itm1, sclk_itm2, sclk_itm3, N7, ws_itm1, ws_itm2, N14, N15,
         N16, N17, N18, N19, N20, N21, N22, n1, n10, n11, n12, n13, n14, n15,
         n16, n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29,
         n30, n31, n32, n33, n34, n35, n36, n37, n38, n55, n57, n59, n61, n63,
         n65, n67, n69, n71, n73, n75, n77, n79, n81, n83, n85, n87, n89, n91,
         n93, n95, n97, n99, n101, n103, n105, n107, n109, n111, n113, n115,
         n117, n120, n121, n122, n123, n124, n125, n126, n127, n128, n129,
         n130, n131, n132, n133;
  wire   [4:0] bit_cntr;
  wire   [1:0] state;
  wire   [1:0] nxt_state;
  wire   [4:2] \add_49_S2/carry ;

  DFCNQD1BWP sclk_itm1_reg ( .D(I2S_sclk), .CP(clk), .CDN(rst_n), .Q(sclk_itm1) );
  DFCNQD1BWP sclk_itm2_reg ( .D(sclk_itm1), .CP(clk), .CDN(rst_n), .Q(
        sclk_itm2) );
  DFCNQD1BWP sclk_itm3_reg ( .D(sclk_itm2), .CP(clk), .CDN(rst_n), .Q(
        sclk_itm3) );
  DFCNQD1BWP \state_reg[0]  ( .D(nxt_state[0]), .CP(clk), .CDN(rst_n), .Q(
        state[0]) );
  DFCNQD1BWP \bit_cntr_reg[0]  ( .D(N18), .CP(clk), .CDN(rst_n), .Q(
        bit_cntr[0]) );
  DFCNQD1BWP \bit_cntr_reg[1]  ( .D(N19), .CP(clk), .CDN(rst_n), .Q(
        bit_cntr[1]) );
  DFCNQD1BWP \bit_cntr_reg[2]  ( .D(N20), .CP(clk), .CDN(rst_n), .Q(
        bit_cntr[2]) );
  DFCNQD1BWP \bit_cntr_reg[3]  ( .D(N21), .CP(clk), .CDN(rst_n), .Q(
        bit_cntr[3]) );
  DFCNQD1BWP \bit_cntr_reg[4]  ( .D(N22), .CP(clk), .CDN(rst_n), .Q(
        bit_cntr[4]) );
  DFCNQD1BWP \state_reg[1]  ( .D(nxt_state[1]), .CP(clk), .CDN(rst_n), .Q(
        state[1]) );
  XNR2D1BWP U12 ( .A1(n128), .A2(I2S_ws), .ZN(n18) );
  OA21D1BWP U20 ( .A1(n133), .A2(n10), .B(n13), .Z(n21) );
  DFSNQD1BWP ws_itm2_reg ( .D(ws_itm1), .CP(clk), .SDN(rst_n), .Q(ws_itm2) );
  DFSND1BWP ws_itm3_reg ( .D(ws_itm2), .CP(clk), .SDN(rst_n), .QN(n1) );
  DFSNQD1BWP ws_itm1_reg ( .D(I2S_ws), .CP(clk), .SDN(rst_n), .Q(ws_itm1) );
  EDFCND1BWP \shft_reg_reg[5]  ( .D(rght_chnnl[4]), .E(n123), .CP(clk), .CDN(
        rst_n), .QN(n111) );
  EDFCND1BWP \shft_reg_reg[4]  ( .D(rght_chnnl[3]), .E(n123), .CP(clk), .CDN(
        rst_n), .QN(n103) );
  EDFCND1BWP \shft_reg_reg[3]  ( .D(rght_chnnl[2]), .E(n123), .CP(clk), .CDN(
        rst_n), .QN(n95) );
  EDFCND1BWP \shft_reg_reg[2]  ( .D(rght_chnnl[1]), .E(n123), .CP(clk), .CDN(
        rst_n), .QN(n87) );
  EDFCND1BWP \shft_reg_reg[1]  ( .D(rght_chnnl[0]), .E(n123), .CP(clk), .CDN(
        rst_n), .QN(n79) );
  EDFCND1BWP \shft_reg_reg[46]  ( .D(lft_chnnl[21]), .E(n120), .CP(clk), .CDN(
        rst_n), .QN(n117) );
  EDFCND1BWP \shft_reg_reg[45]  ( .D(lft_chnnl[20]), .E(n120), .CP(clk), .CDN(
        rst_n), .QN(n109) );
  EDFCND1BWP \shft_reg_reg[44]  ( .D(lft_chnnl[19]), .E(n120), .CP(clk), .CDN(
        rst_n), .QN(n101) );
  EDFCND1BWP \shft_reg_reg[43]  ( .D(lft_chnnl[18]), .E(n120), .CP(clk), .CDN(
        rst_n), .QN(n93) );
  EDFCND1BWP \shft_reg_reg[42]  ( .D(lft_chnnl[17]), .E(n120), .CP(clk), .CDN(
        rst_n), .QN(n85) );
  EDFCND1BWP \shft_reg_reg[41]  ( .D(lft_chnnl[16]), .E(n120), .CP(clk), .CDN(
        rst_n), .QN(n77) );
  EDFCND1BWP \shft_reg_reg[39]  ( .D(lft_chnnl[14]), .E(n120), .CP(clk), .CDN(
        rst_n), .QN(n71) );
  EDFCND1BWP \shft_reg_reg[38]  ( .D(lft_chnnl[13]), .E(n120), .CP(clk), .CDN(
        rst_n), .QN(n65) );
  EDFCND1BWP \shft_reg_reg[37]  ( .D(lft_chnnl[12]), .E(n120), .CP(clk), .CDN(
        rst_n), .QN(n59) );
  EDFCND1BWP \shft_reg_reg[47]  ( .D(lft_chnnl[22]), .E(n120), .CP(clk), .CDN(
        rst_n), .QN(n38) );
  EDFCND1BWP \shft_reg_reg[40]  ( .D(lft_chnnl[15]), .E(n121), .CP(clk), .CDN(
        rst_n), .QN(n115) );
  EDFCND1BWP \shft_reg_reg[36]  ( .D(lft_chnnl[11]), .E(n121), .CP(clk), .CDN(
        rst_n), .QN(n107) );
  EDFCND1BWP \shft_reg_reg[35]  ( .D(lft_chnnl[10]), .E(n121), .CP(clk), .CDN(
        rst_n), .QN(n99) );
  EDFCND1BWP \shft_reg_reg[34]  ( .D(lft_chnnl[9]), .E(n121), .CP(clk), .CDN(
        rst_n), .QN(n91) );
  EDFCND1BWP \shft_reg_reg[33]  ( .D(lft_chnnl[8]), .E(n121), .CP(clk), .CDN(
        rst_n), .QN(n83) );
  EDFCND1BWP \shft_reg_reg[32]  ( .D(lft_chnnl[7]), .E(n121), .CP(clk), .CDN(
        rst_n), .QN(n75) );
  EDFCND1BWP \shft_reg_reg[31]  ( .D(lft_chnnl[6]), .E(n121), .CP(clk), .CDN(
        rst_n), .QN(n69) );
  EDFCND1BWP \shft_reg_reg[30]  ( .D(lft_chnnl[5]), .E(n121), .CP(clk), .CDN(
        rst_n), .QN(n63) );
  EDFCND1BWP \shft_reg_reg[29]  ( .D(lft_chnnl[4]), .E(n121), .CP(clk), .CDN(
        rst_n), .QN(n57) );
  EDFCND1BWP \shft_reg_reg[21]  ( .D(rght_chnnl[20]), .E(n122), .CP(clk), 
        .CDN(rst_n), .QN(n113) );
  EDFCND1BWP \shft_reg_reg[20]  ( .D(rght_chnnl[19]), .E(n122), .CP(clk), 
        .CDN(rst_n), .QN(n105) );
  EDFCND1BWP \shft_reg_reg[19]  ( .D(rght_chnnl[18]), .E(n122), .CP(clk), 
        .CDN(rst_n), .QN(n97) );
  EDFCND1BWP \shft_reg_reg[18]  ( .D(rght_chnnl[17]), .E(n122), .CP(clk), 
        .CDN(rst_n), .QN(n89) );
  EDFCND1BWP \shft_reg_reg[17]  ( .D(rght_chnnl[16]), .E(n122), .CP(clk), 
        .CDN(rst_n), .QN(n81) );
  EDFCND1BWP \shft_reg_reg[16]  ( .D(rght_chnnl[15]), .E(n122), .CP(clk), 
        .CDN(rst_n), .QN(n73) );
  EDFCND1BWP \shft_reg_reg[15]  ( .D(rght_chnnl[14]), .E(n122), .CP(clk), 
        .CDN(rst_n), .QN(n67) );
  EDFCND1BWP \shft_reg_reg[14]  ( .D(rght_chnnl[13]), .E(n122), .CP(clk), 
        .CDN(rst_n), .QN(n61) );
  EDFCND1BWP \shft_reg_reg[13]  ( .D(rght_chnnl[12]), .E(n122), .CP(clk), 
        .CDN(rst_n), .QN(n55) );
  EDFCND1BWP \shft_reg_reg[26]  ( .D(lft_chnnl[1]), .E(n121), .CP(clk), .CDN(
        rst_n), .QN(n24) );
  EDFCND1BWP \shft_reg_reg[10]  ( .D(rght_chnnl[9]), .E(n122), .CP(clk), .CDN(
        rst_n), .QN(n23) );
  EDFCND1BWP \shft_reg_reg[0]  ( .D(I2S_data), .E(n120), .CP(clk), .CDN(rst_n), 
        .QN(n37) );
  EDFCND1BWP \shft_reg_reg[28]  ( .D(lft_chnnl[3]), .E(n121), .CP(clk), .CDN(
        rst_n), .QN(n36) );
  EDFCND1BWP \shft_reg_reg[27]  ( .D(lft_chnnl[2]), .E(n121), .CP(clk), .CDN(
        rst_n), .QN(n30) );
  EDFCND1BWP \shft_reg_reg[25]  ( .D(lft_chnnl[0]), .E(n121), .CP(clk), .CDN(
        rst_n), .QN(n34) );
  EDFCND1BWP \shft_reg_reg[24]  ( .D(rght_chnnl[23]), .E(n121), .CP(clk), 
        .CDN(rst_n), .QN(n29) );
  EDFCND1BWP \shft_reg_reg[23]  ( .D(rght_chnnl[22]), .E(n121), .CP(clk), 
        .CDN(rst_n), .QN(n32) );
  EDFCND1BWP \shft_reg_reg[22]  ( .D(rght_chnnl[21]), .E(n121), .CP(clk), 
        .CDN(rst_n), .QN(n28) );
  EDFCND1BWP \shft_reg_reg[12]  ( .D(rght_chnnl[11]), .E(n122), .CP(clk), 
        .CDN(rst_n), .QN(n35) );
  EDFCND1BWP \shft_reg_reg[11]  ( .D(rght_chnnl[10]), .E(n122), .CP(clk), 
        .CDN(rst_n), .QN(n27) );
  EDFCND1BWP \shft_reg_reg[9]  ( .D(rght_chnnl[8]), .E(n122), .CP(clk), .CDN(
        rst_n), .QN(n33) );
  EDFCND1BWP \shft_reg_reg[8]  ( .D(rght_chnnl[7]), .E(n122), .CP(clk), .CDN(
        rst_n), .QN(n26) );
  EDFCND1BWP \shft_reg_reg[7]  ( .D(rght_chnnl[6]), .E(n122), .CP(clk), .CDN(
        rst_n), .QN(n31) );
  EDFCND1BWP \shft_reg_reg[6]  ( .D(rght_chnnl[5]), .E(n122), .CP(clk), .CDN(
        rst_n), .QN(n25) );
  CKND12BWP U33 ( .I(n25), .ZN(rght_chnnl[6]) );
  CKND12BWP U34 ( .I(n31), .ZN(rght_chnnl[7]) );
  CKND12BWP U35 ( .I(n26), .ZN(rght_chnnl[8]) );
  CKND12BWP U36 ( .I(n33), .ZN(rght_chnnl[9]) );
  CKND12BWP U37 ( .I(n27), .ZN(rght_chnnl[11]) );
  CKND12BWP U38 ( .I(n35), .ZN(rght_chnnl[12]) );
  CKND12BWP U39 ( .I(n28), .ZN(rght_chnnl[22]) );
  CKND12BWP U40 ( .I(n32), .ZN(rght_chnnl[23]) );
  CKND12BWP U41 ( .I(n29), .ZN(lft_chnnl[0]) );
  CKND12BWP U42 ( .I(n34), .ZN(lft_chnnl[1]) );
  CKND12BWP U43 ( .I(n30), .ZN(lft_chnnl[3]) );
  CKND12BWP U44 ( .I(n36), .ZN(lft_chnnl[4]) );
  CKND12BWP U45 ( .I(n38), .ZN(lft_chnnl[23]) );
  CKND12BWP U46 ( .I(n23), .ZN(rght_chnnl[10]) );
  CKND12BWP U47 ( .I(n24), .ZN(lft_chnnl[2]) );
  CKND12BWP U48 ( .I(n37), .ZN(rght_chnnl[0]) );
  CKND12BWP U49 ( .I(n55), .ZN(rght_chnnl[13]) );
  CKND12BWP U50 ( .I(n57), .ZN(lft_chnnl[5]) );
  CKND12BWP U51 ( .I(n59), .ZN(lft_chnnl[13]) );
  CKND12BWP U52 ( .I(n61), .ZN(rght_chnnl[14]) );
  CKND12BWP U53 ( .I(n63), .ZN(lft_chnnl[6]) );
  CKND12BWP U54 ( .I(n65), .ZN(lft_chnnl[14]) );
  CKND12BWP U55 ( .I(n67), .ZN(rght_chnnl[15]) );
  CKND12BWP U56 ( .I(n69), .ZN(lft_chnnl[7]) );
  CKND12BWP U57 ( .I(n71), .ZN(lft_chnnl[15]) );
  CKND12BWP U58 ( .I(n73), .ZN(rght_chnnl[16]) );
  CKND12BWP U59 ( .I(n75), .ZN(lft_chnnl[8]) );
  CKND12BWP U60 ( .I(n77), .ZN(lft_chnnl[17]) );
  CKND12BWP U61 ( .I(n79), .ZN(rght_chnnl[1]) );
  CKND12BWP U62 ( .I(n81), .ZN(rght_chnnl[17]) );
  CKND12BWP U63 ( .I(n83), .ZN(lft_chnnl[9]) );
  CKND12BWP U64 ( .I(n85), .ZN(lft_chnnl[18]) );
  CKND12BWP U65 ( .I(n87), .ZN(rght_chnnl[2]) );
  CKND12BWP U66 ( .I(n89), .ZN(rght_chnnl[18]) );
  CKND12BWP U67 ( .I(n91), .ZN(lft_chnnl[10]) );
  CKND12BWP U68 ( .I(n93), .ZN(lft_chnnl[19]) );
  CKND12BWP U69 ( .I(n95), .ZN(rght_chnnl[3]) );
  CKND12BWP U70 ( .I(n97), .ZN(rght_chnnl[19]) );
  CKND12BWP U71 ( .I(n99), .ZN(lft_chnnl[11]) );
  CKND12BWP U72 ( .I(n101), .ZN(lft_chnnl[20]) );
  CKND12BWP U73 ( .I(n103), .ZN(rght_chnnl[4]) );
  CKND12BWP U74 ( .I(n105), .ZN(rght_chnnl[20]) );
  CKND12BWP U75 ( .I(n107), .ZN(lft_chnnl[12]) );
  CKND12BWP U76 ( .I(n109), .ZN(lft_chnnl[21]) );
  CKND12BWP U77 ( .I(n111), .ZN(rght_chnnl[5]) );
  CKND12BWP U78 ( .I(n113), .ZN(rght_chnnl[21]) );
  CKND12BWP U79 ( .I(n115), .ZN(lft_chnnl[16]) );
  CKND12BWP U80 ( .I(n117), .ZN(lft_chnnl[22]) );
  OR2XD1BWP U81 ( .A1(n10), .A2(n11), .Z(n134) );
  CKND12BWP U82 ( .I(n134), .ZN(vld) );
  CKBD3BWP U83 ( .I(n125), .Z(n120) );
  IND2D1BWP U84 ( .A1(n123), .B1(n21), .ZN(n19) );
  CKBD3BWP U85 ( .I(n125), .Z(n121) );
  CKBD3BWP U86 ( .I(n124), .Z(n122) );
  AN2XD1BWP U87 ( .A1(n21), .A2(n120), .Z(n20) );
  CKBD1BWP U88 ( .I(n124), .Z(n123) );
  CKBD1BWP U89 ( .I(N7), .Z(n125) );
  MOAI22D0BWP U90 ( .A1(n131), .A2(n19), .B1(N16), .B2(n20), .ZN(N21) );
  MOAI22D0BWP U91 ( .A1(n130), .A2(n19), .B1(N15), .B2(n20), .ZN(N20) );
  OAI21D1BWP U92 ( .A1(n12), .A2(n133), .B(n13), .ZN(nxt_state[1]) );
  NR2XD0BWP U93 ( .A1(n126), .A2(n14), .ZN(n12) );
  CKBD1BWP U94 ( .I(N7), .Z(n124) );
  ND4D1BWP U95 ( .A1(bit_cntr[3]), .A2(bit_cntr[4]), .A3(n22), .A4(n128), .ZN(
        n10) );
  NR2XD0BWP U96 ( .A1(bit_cntr[2]), .A2(bit_cntr[1]), .ZN(n22) );
  ND4D1BWP U97 ( .A1(n120), .A2(n131), .A3(bit_cntr[1]), .A4(n17), .ZN(n14) );
  NR3D0BWP U98 ( .A1(n18), .A2(n130), .A3(n132), .ZN(n17) );
  INR2D1BWP U99 ( .A1(sclk_itm2), .B1(sclk_itm3), .ZN(N7) );
  ND3D1BWP U100 ( .A1(state[0]), .A2(n14), .A3(state[1]), .ZN(n11) );
  INVD1BWP U101 ( .I(bit_cntr[0]), .ZN(n128) );
  INVD1BWP U102 ( .I(bit_cntr[2]), .ZN(n130) );
  INVD1BWP U103 ( .I(bit_cntr[4]), .ZN(n132) );
  INVD1BWP U104 ( .I(bit_cntr[3]), .ZN(n131) );
  INVD1BWP U105 ( .I(state[1]), .ZN(n133) );
  INVD1BWP U106 ( .I(state[0]), .ZN(n126) );
  ND3D1BWP U107 ( .A1(n120), .A2(n133), .A3(state[0]), .ZN(n13) );
  MOAI22D0BWP U108 ( .A1(n132), .A2(n19), .B1(N17), .B2(n20), .ZN(N22) );
  MOAI22D0BWP U109 ( .A1(n129), .A2(n19), .B1(N14), .B2(n20), .ZN(N19) );
  INVD1BWP U110 ( .I(bit_cntr[1]), .ZN(n129) );
  MOAI22D0BWP U111 ( .A1(n128), .A2(n19), .B1(n128), .B2(n20), .ZN(N18) );
  OAI21D1BWP U112 ( .A1(n127), .A2(n11), .B(n15), .ZN(nxt_state[0]) );
  AOI32D1BWP U113 ( .A1(state[1]), .A2(n126), .A3(n127), .B1(n16), .B2(n133), 
        .ZN(n15) );
  INVD1BWP U114 ( .I(n10), .ZN(n127) );
  OAI32D1BWP U115 ( .A1(n1), .A2(ws_itm2), .A3(state[0]), .B1(n120), .B2(n126), 
        .ZN(n16) );
  HA1D0BWP U116 ( .A(bit_cntr[1]), .B(bit_cntr[0]), .CO(\add_49_S2/carry [2]), 
        .S(N14) );
  HA1D0BWP U117 ( .A(bit_cntr[2]), .B(\add_49_S2/carry [2]), .CO(
        \add_49_S2/carry [3]), .S(N15) );
  HA1D0BWP U118 ( .A(bit_cntr[3]), .B(\add_49_S2/carry [3]), .CO(
        \add_49_S2/carry [4]), .S(N16) );
  CKXOR2D0BWP U119 ( .A1(\add_49_S2/carry [4]), .A2(bit_cntr[4]), .Z(N17) );
endmodule

