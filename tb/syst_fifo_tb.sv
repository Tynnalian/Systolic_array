`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.05.2024 20:07:08
// Design Name: 
// Module Name: syst_fifo_tb
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


module syst_fifo_tb();

 logic              clk_i;
 logic              rst_i;
 logic [32-1:0]     data_i;
 logic [32-1:0]     data_o;
 logic              valid_i;
 logic              ready_i;
 logic              valid_o;
   
 
 syst_fifo syst_fifo (
 .clk_i (clk_i),
 .rst_i (rst_i),
 .data_i (data_i),
 .valid_i (valid_i),
 .data_o (data_o),
 .ready_i(ready_i),
 .valid_o(valid_o)
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
 ready_i=1;
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
 #150
 $stop();
 
  
 
 
 
 
 end
 
endmodule
