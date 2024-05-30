`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.04.2024 08:35:59
// Design Name: 
// Module Name: sys_node
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


module syst_node
#(
  parameter W_WIDTH  = 8,
  parameter X_WIDTH  = 8,
  parameter SI_WIDTH = 8,
  parameter SO_WIDTH = 17
)
(
  input  logic                clk_i,
  input  logic                rst_i,
  //input  logic                valid_ps_i,
  input  logic                valid_i,
  input  logic [W_WIDTH -1:0] weight_i,
  input  logic [SI_WIDTH-1:0] psumm_i,  
  input  logic [X_WIDTH -1:0] x_i,
  output logic [SO_WIDTH-1:0] psumm_o,
  output logic [X_WIDTH -1:0] x_o,
  //output logic                ready_o,
 // output logic                valid_ps_o,
  output logic                valid_o
  
);

  logic [X_WIDTH        -1:0] x_ff;
  logic [SO_WIDTH       -1:0] psumm_ff;
  logic [X_WIDTH+W_WIDTH-1:0] weight_mult;
  logic                       valid_ff;
  logic                       en;
 // assign ready_o = valid_ps_i;
  assign weight_mult = x_i * weight_i;
  assign en=valid_i;
  

  always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i)
      psumm_ff <= '0;
    else if (en ) //else if (valid_i & ready_o)
      psumm_ff <= psumm_i + weight_mult;
  end

  always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i)
      x_ff <= '0;
    else if (en) //(valid_i & ready_o)
      x_ff <= x_i;
  end
  
  
always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i)
      valid_ff <= '0;
    else //(valid_i & ready_o)
      valid_ff <= en;
  end
    

  assign psumm_o = psumm_ff;
  assign x_o     = x_ff;
  assign valid_o = valid_ff;
 // assign valid_ps_o = valid_ff;

endmodule
 