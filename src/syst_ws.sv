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



module syst_ws
#(parameter col = 4,
  parameter str = 4 ,
  parameter weight = 8)

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
  
 
 // input  logic   valid_ps1_i  ,
//  input  logic   valid_ps2_i  ,
 // input  logic   valid_ps3_i  ,
//  input  logic   valid_ps4_i  ,
 // input  logic   valid_ps5_i  ,
  //input  logic  [20:0]  psumm_i [str-1:0],
  
  /*output logic          ready1_o ,
  output logic          ready2_o ,
  output logic          ready3_o ,
  output logic          ready4_o ,
  output logic          ready5_o ,*/
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


  localparam W_WIDTH = 8;
  localparam X_WIDTH = 8;
  
  logic [7:0]  x_pipe [str:0] [col:0];
 // logic        valid_ps [str-1:0] [col-1:0];
  logic         valid   [str:0] [col:0];
  logic         ready   [str-1:0] [col-1:0];
  logic valid_i [col-1:0];
  
 // logic [16:0] psumm11;
 // logic [17:0] psumm12;
 // logic [18:0] psumm13;
 // logic [16:0] psumm21;
 // logic [17:0] psumm22;
 // logic [18:0] psumm23;
  logic [weight*2+col-1:0] psumm [str:0] [col:0];
 

  // Exercise: Add nodes 13 and 23 to systolic array


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
                     .weight_i (weight),            //(i+1)*(i+1)+j+1
                     .x_i ( x_pipe [i] [j]),
                     .psumm_i (psumm [i] [j]),
                     //.valid_ps_i (valid_ps [i] [j]),
                     .valid_i    (valid [i] [j]  ),
                     //.ready_o  (ready [i] [j]),
                     .x_o        (x_pipe [i+1] [j]),
                     .valid_o  (valid [i+1] [j]),
                     .psumm_o (psumm [i] [j+1])
                     //.valid_ps_o (valid_ps [i] [j+1])
                  
                     
               );
               
               /*if (i==0 && j==0) begin
               
               assign  x_i [0] =  x_pipe [0] [0];
               assign  valid_i [0] = valid [0] [0] ;
               assign  valid_ps_i [0] = valid_ps [0] [0];
               assign  psumm [0] [0] =0;
               end
               
            //   else if (i==0 && j==col-1) begin
               //  assign  valid_ps_i [0] = valid_ps [0] [j];
             //    assign  y_o [0] [0] = psumm [0] [col] ;
             //  end
           
               
               else if (i==0) begin
               assign x_i [j] = x_pipe [0] [j] ;
               assign valid_i [j]  = valid [0] [j] ;
               end
               
               else if(j==0) begin
               assign valid_ps_i [i] = valid_ps [i] [0];
               assign psumm [i] [0] =0;
               end
               
              // else if (j==col-1) begin
              // assign y_o [i]  = psumm [i] [col] ;
              // end */
               
               
            end
        end
    endgenerate  
    // inputs
    assign x_pipe [0] [0]  = x1_i;
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
    
   // assign  valid_ps [0] [0] = valid_ps1_i;
   // assign  valid_ps [1] [0] = valid_ps2_i;
   // assign  valid_ps [2] [0] = valid_ps3_i;
   // assign  valid_ps [3] [0] = valid_ps4_i;
   // assign  valid_ps [4] [0] = valid_ps5_i;
    
    
   // assign ready1_o=ready [0] [0];
   // assign ready2_o=ready [0] [1];
   // assign ready3_o=ready [0] [2];
  //  assign ready4_o=ready [0] [3];
   // assign ready5_o=ready [0] [4];
  //  assign ready6_o=ready [0] [5];
    
    assign y1_o=psumm [0] [col];
    assign y2_o=psumm [1] [col];
    assign y3_o=psumm [2] [col];
    assign y4_o=psumm [3] [col];
    

endmodule