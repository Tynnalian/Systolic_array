`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.05.2024 20:32:17
// Design Name: 
// Module Name: wrapper_tb
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


module wrapper_tb();
 logic              clk_i;
 logic              rst_i;
 logic [32-1:0]     data_i;
 logic              valid_i;
 logic [19:0]   y1 ;
   logic [19:0]   y2 ;
   logic [19:0]   y3 ;
   logic [19:0]  y4 ;
   
 
 syst_wrapper syst_wrapper (
 .clk_i (clk_i),
 .rst_i (rst_i),
 .data_i (data_i),
 .valid_i (valid_i),
 .y1   (y1),
 .y2   (y2),
 .y3   (y3),
 .y4   (y4)
 );
 
 initial begin
 clk_i <=0;
 forever # 5 clk_i <= ~clk_i;
 end
 
 initial begin
 rst_i=1;
 @(posedge clk_i) rst_i=0;
 end
 
 initial begin
 valid_i=0;
 wait(~rst_i)
 @(posedge clk_i)
 data_i = 32'b00000010000000100000001000000010;
 valid_i=1;
 
 #20 valid_i=0;
 #30
 data_i = 32'b00000011000000110000001100000011;
 #60 valid_i=0;
 
 #20 valid_i=0;
 repeat(10) begin
    @(posedge clk_i);
    data_i =$urandom;
    valid_i=1;
    #5 valid_i=0;
 end
 valid_i=0;
 #100
 $stop();
 
  
 
 
 
 
 end
 
 
 
 
 
  










endmodule
