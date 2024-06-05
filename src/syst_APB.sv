`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 29.05.2024 18:34:06
// Design Name:
// Module Name: syst_APB
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module syst_APB(
  input  logic        p_clk_i,
  input  logic        p_rst_i,
  input  logic [31:0] p_dat_i,
  output logic [31:0] p_dat_o,
  input  logic        p_sel_i,
  input  logic        p_enable_i,
  input  logic        p_we_i,
  input  logic [31:0] p_adr_i,
  output logic        p_ready,
  output logic        p_slverr

    );



  logic [31:0] din_i;
  logic [31:0] systd_o;
  logic [1:0] state;
  logic       syst_rd;
  logic       data_valid_i;
  logic       data_valid_o;
  assign p_slverr = 1'b0;


 logic w_valid_raw1;
 logic w_valid_raw2;
 logic w_valid_raw3;
 logic w_valid_raw4;

    syst_fifo syst_array
    ( .clk_i(p_clk_i),
       .rst_i(p_rst_i),
       .data_i(din_i),
       .valid_i(data_valid_i),
       .valid_raw_1_i(w_valid_raw1),
       .valid_raw_2_i(w_valid_raw2),
       .valid_raw_3_i(w_valid_raw3),
       .valid_raw_4_i(w_valid_raw4),
       .ready_i(syst_rd),
       .valid_o(data_valid_o),
       .data_o (systd_o)
  );


  logic cs_1_ff;
  logic cs_2_ff;

  logic cs_ack1_ff;
  logic cs_ack2_ff;

  always_ff @ (posedge p_clk_i)
  begin
      cs_1_ff <= p_enable_i & p_sel_i;
      cs_2_ff <= cs_1_ff;
  end

  logic cs;
  assign cs = cs_1_ff & (~cs_2_ff);

  always_ff @ (posedge p_clk_i)
  begin
    cs_ack1_ff <= cs_2_ff;
    cs_ack2_ff <= cs_ack1_ff;
  end

  // Generating acknowledge signal
  logic p_ready_ff;

  always_ff @ (posedge p_clk_i)
  begin
    p_ready_ff <= (cs_ack1_ff & (~cs_ack2_ff));
  end

  assign p_ready = p_ready_ff;

  always_comb
  begin

    if (  (~p_we_i) & (p_adr_i[5:0] == 4'd4))
      p_dat_o = systd_o;
     else p_dat_o =32'b0;

  end

  logic addr_for_wr ;
  assign addr_for_wr =( p_adr_i[5:0]  == 6'd0)|(p_adr_i[5:0]  == 6'd8)|(p_adr_i[5:0]  == 6'd12)|(p_adr_i[5:0]  == 6'd16)|(p_adr_i[5:0]  == 6'd20);

  assign w_valid_raw1 = (cs & p_we_i & p_adr_i[5:0]  == 'd8);
  assign w_valid_raw2 = (cs & p_we_i & p_adr_i[5:0]  == 'd12);
  assign w_valid_raw3 = (cs & p_we_i & p_adr_i[5:0]  == 'd16);
  assign w_valid_raw4 = (cs & p_we_i & p_adr_i[5:0]  == 'd20);

  assign data_valid_i = (cs & p_we_i & p_adr_i[5:0]  == 4'd0);
  assign din_i        = (cs & p_we_i & addr_for_wr) ? p_dat_i: 32'd0;
  assign syst_rd       = (cs & ~p_we_i & p_adr_i[3:0] == 4'd4);


endmodule
