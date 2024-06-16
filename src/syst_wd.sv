`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 22.04.2024 08:38:44
// Design Name:
// Module Name: syst_ws
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



module syst_wd
#(parameter col = 4,
  parameter str = 4 ,
  parameter W_WIDTH = 8)

(
  input  logic clk_i,
  input  logic rst_i,

  input  logic [7:0] x1_i    ,
  input  logic [7:0] x2_i    ,
  input  logic [7:0] x3_i    ,
  input  logic [7:0] x4_i    ,


  input  logic   valid1_i    ,
  input  logic   valid2_i    ,
  input  logic   valid3_i    ,
  input  logic   valid4_i    ,

  input logic [W_WIDTH-1:0]  weight_i  [str-1:0] [col-1:0],
  input logic   valid_w_i [str-1:0] [col-1:0],

  output logic [19:0] y1_o ,
  output logic [19:0] y2_o ,
  output logic [19:0] y3_o ,
  output logic [19:0] y4_o


);

  localparam W11 = 8'd2;
  localparam W12 = 8'd3;
  localparam W13 = 8'd4;
  localparam W21 = 8'd5;
  localparam W22 = 8'd6;
  localparam W23 = 8'd7;



  logic [7:0]  x_pipe [str:0] [col:0];

  logic         valid   [str:0] [col:0];
  logic         ready   [str-1:0] [col-1:0];
  logic valid_i [col-1:0];


  logic [W_WIDTH*2+col-1:0] psumm [str:0] [col:0];

    generate
        for(genvar i = 0; i < str; i++) begin : stroka
            for(genvar j = 0; j < col; j++) begin : column

            //create and connect node
                syst_node #(
                     .W_WIDTH  (8),
                     .X_WIDTH  (8),
                     .SI_WIDTH (17+j-1),
                     .SO_WIDTH (8*2+j+1)
                   ) node (
                     .clk_i    (clk_i),
                     .rst_i    (rst_i),
                     .weight_i (weight_i [i] [j]),
                     .valid_w_i (valid_w_i [i] [j]),
                     .x_i ( x_pipe [i] [j]),
                     .psumm_i (psumm [i] [j]),
                     .valid_i    (valid [i] [j]  ),
                     .x_o        (x_pipe [i+1] [j]),
                     .valid_o  (valid [i+1] [j]),
                     .psumm_o (psumm [i] [j+1])



               );



            end
        end
    endgenerate

    assign x_pipe [0] [0] = x1_i;
    assign x_pipe [0] [1] = x2_i;
    assign x_pipe [0] [2] = x3_i;
    assign x_pipe [0] [3] = x4_i;


    assign  valid [0] [0] = valid1_i;
    assign  valid [0] [1] = valid2_i;
    assign  valid [0] [2] = valid3_i;
    assign  valid [0] [3] = valid4_i;


    assign psumm [0] [0] =0;
    assign psumm [1] [0] =0;
    assign psumm [2] [0] =0;
    assign psumm [3] [0] =0;
    assign psumm [4] [0] =0;



    assign y1_o=psumm [0] [col];
    assign y2_o=psumm [1] [col];
    assign y3_o=psumm [2] [col];
    assign y4_o=psumm [3] [col];


endmodule