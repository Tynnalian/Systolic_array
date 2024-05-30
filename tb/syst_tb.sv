`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.04.2024 09:26:10
// Design Name: 
// Module Name: syst_tb
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


module syst_tb();
 logic clk_i;
  logic rst_i;
  logic [7:0] x1_i;
  logic  [7:0] x2_i;
  logic [7:0] x3_i;
  logic [7:0] x4_i;
  logic [7:0] x5_i;
  
   logic   valid1_i    ;
   logic   valid2_i    ;
   logic   valid3_i    ;
   logic   valid4_i    ;
   logic   valid5_i    ;
  
    logic   valid_ps1_i  ;
    logic   valid_ps2_i  ;
    logic   valid_ps3_i  ;
    logic   valid_ps4_i  ;
    logic   valid_ps5_i  ;
  //input  logic  [20:0]  psumm_i [str-1:0],
  
   logic          ready1_o ;
   logic          ready2_o ;
   logic          ready3_o ;
   logic          ready4_o ;
   logic          ready5_o ;
   logic [19:0]   y1_o ;
   logic [19:0]   y2_o ;
   logic [19:0]   y3_o ;
   logic [19:0]  y4_o ;
   logic [19:0]  y5_o ;

  // Выходы
  


   
syst_ws 
                dut (
                 .clk_i    (clk_i),
                 .rst_i    (rst_i),
                             //(i+1)*(i+1)+j+1
                 .x1_i  ( x1_i ),
                 .x2_i ( x2_i ),
                 .x3_i ( x3_i ),
                 .x4_i ( x4_i ),
                 .x5_i ( x5_i ),
                 
                 .valid1_i (valid1_i),
                 .valid2_i (valid2_i),
                 .valid3_i (valid3_i),
                 .valid4_i (valid4_i),
                 .valid5_i (valid5_i),
                 
               /*  .valid_ps1_i (valid_ps1_i),
                 .valid_ps2_i (valid_ps2_i),
                 .valid_ps3_i (valid_ps3_i),
                 .valid_ps4_i (valid_ps4_i),
                 .valid_ps5_i (valid_ps5_i),
                 
                // .ready1_o (ready1_o),
                // .ready2_o (ready2_o),
                // .ready3_o (ready3_o),
                // .ready4_o (ready4_o),
               //  .ready5_o (ready5_o), */
                 
                 .y1_o (y1_o),
                 .y2_o (y2_o),
                 .y3_o (y3_o),
                 .y4_o (y4_o),
                 .y5_o (y5_o) 
                 
                 
                 
                
                
              
                 
           );

  initial begin
    // Инициализация входов
    clk_i = 0;
    rst_i = 1;
    x1_i  = 0;
    x2_i  = 0;
    x3_i  = 0;
    x4_i  = 0;
    x5_i  = 0;
    valid1_i = 0 ;
    valid2_i = 0 ;
    valid3_i = 0 ;
    valid4_i = 0 ;
    valid5_i = 0 ;
  
   
    // Сброс
    #10;
    rst_i = 0;

    // Примеры тестового набора
    @(posedge clk_i);
     valid1_i=1;
      x1_i = 1;
   @(posedge clk_i);
    valid1_i=0;
    valid2_i=1;
    x2_i = 1;
   @(posedge clk_i);
     valid2_i=0;
     valid3_i=1;
     x3_i = 1;
    @(posedge clk_i);
     valid3_i=0;
     valid4_i=1;
     x4_i = 1;
     
    @(posedge clk_i);
     valid4_i=0;
     valid5_i=1;
     x5_i = 1;
    @(posedge clk_i);
     valid5_i=0;
    #120;
    //rst_i = 1;
    #100;
    rst_i = 0;
    #5;
    
    @(posedge clk_i);
     valid1_i=1;
      x1_i = 2;
   @(posedge clk_i);
    valid1_i=0;
    valid2_i=0;
    x2_i = 2;
   @(posedge clk_i);
     valid2_i=0;
     valid3_i=1;
     x3_i = 2;
    @(posedge clk_i);
     valid3_i=0;
     valid4_i=1;
     x4_i = 2;
     
    @(posedge clk_i);
     valid4_i=0;
     valid5_i=1;
     x5_i = 1;
    @(posedge clk_i);
     valid5_i=0;
    #120

    // Завершение симуляции
    $finish;
  end
  
  
  
    

  // Генерация тактового сигнала
  always #5 clk_i = ~clk_i;
 


endmodule
