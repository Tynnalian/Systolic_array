`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.05.2024 18:06:38
// Design Name: 
// Module Name: syst_fifo
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


module syst_fifo 
#(parameter WORD  = 32,
  parameter X_WIDTH  = 8,
  parameter col  =  4, 
  parameter SO_WIDTH = 19)
(
 input  logic            clk_i,
 input  logic            rst_i,
 input  logic [WORD-1:0] data_i,
 input  logic            valid_i,
 input logic             ready_i,
 output logic [WORD-1:0]  data_o,
 output logic            valid_o 
        

    );
    logic [WORD-1:0] data_ffo_i;
    logic            valid_ffo_i;
    
    syst_wrapper syst_wrapper 
   /* #(parameter WORD  = 32,
  parameter X_WIDTH  = 8,
  parameter col  =  4, 
  parameter SO_WIDTH = 19) */
( .clk_i (clk_i),
  .rst_i (rst_i),
  .valid_i(valid_i),
  .data_i (data_i),
  .valid_o (valid_ffo_i),
  .data_o  (data_ffo_i)
  );
  
  logic wr_en;
  logic rd_en;
  logic full;
  logic empty;
  
  assign wr_en = valid_ffo_i & (~full);
  assign rd_en = ~empty & (ready_i);
  
  //Подключение FIFO
  fifo_generator_0 fifo (
  .clk (clk_i),
  .rst (rst_i),
  .din (data_ffo_i),
  .wr_en (wr_en),
  .rd_en (rd_en),
   .dout (data_o),
   .full (full),
   .empty (empty)
   );
   // сигнал валидности данных выходящих из FIFO 
   //чтение синхронное, поэтому на валидность тоже устанавливаем регистр
   //чтение синхронное, поэтому на валидность тоже устанавливаем регистр
   logic valid_ff;
   always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i) valid_ff <= 0;
    else valid_ff <=~empty;
   end
   
  assign valid_o = valid_ff;
    
    
    
    
endmodule
