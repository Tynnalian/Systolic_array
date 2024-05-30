`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.05.2024 18:59:23
// Design Name: 
// Module Name: syst_wrapper
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


module syst_wrapper
#(parameter WORD  = 32,
  parameter X_WIDTH  = 8,
  parameter col  =  4, 
  parameter SO_WIDTH = 19)
  
  (input logic              clk_i,
   input logic              rst_i,
   input logic [WORD-1:0]   data_i,
   input logic              valid_i,
   output logic [19:0] y1 ,
   output logic [19:0] y2 ,
   output logic [19:0] y3 ,
   output logic [19:0] y4 ,
   output logic [WORD-1:0] data_o,
   output logic            valid_o
  );
  
  logic [X_WIDTH-1:0] x_ff [col-1:0];
  logic [X_WIDTH-1:0] x2_ff;
  logic [X_WIDTH-1:0] x3_ff [1:0];
  logic [X_WIDTH-1:0] x4_ff [2:0];
  logic           valid_ff [2*col-1:0];
  logic [X_WIDTH-1:0] x [col-1:0];
  logic           valid [col-1:0];
  
  // подключение систолического массива
  syst_ws syst_ws (
  .clk_i (clk_i),
  .rst_i (rst_i),
  .x1_i (x [0]),
  .x2_i (x [1]),
  .x3_i (x [2]),
  .x4_i (x [3]),
  .valid1_i (valid [0]),
  .valid2_i (valid [1]),
  .valid3_i (valid [2]),
  .valid4_i (valid [3]),
  .y1_o     (y1),
  .y2_o     (y2),
  .y3_o     (y3),
  .y4_o     (y4)
  );
  
  
  
  // цепочка сигнала валдиности , передающийся вместе с данными
   always_ff @(posedge clk_i or posedge rst_i) begin
    
    if (rst_i) begin
    
        valid_ff [0] <= 0;
        valid_ff [1] <= 0;
        valid_ff [2] <= 0;
        valid_ff [3] <= 0;
        valid_ff [4] <= 0;
        valid_ff [5] <= 0;
        valid_ff [6] <= 0;
        valid_ff [7] <= 0;
        end
     else begin
        valid_ff [0] <= valid_i;
        valid_ff [1] <= valid_ff [0];
        valid_ff [2] <= valid_ff [1];
        valid_ff [3] <= valid_ff [2];
        valid_ff [4] <= valid_ff [3];
        valid_ff [5] <= valid_ff [4];
        valid_ff [6] <= valid_ff [5];
        valid_ff [7] <= valid_ff [6];
        end
        
        end
  
  // входные регистры
 always_ff @(posedge clk_i or posedge rst_i) begin
    
    if (rst_i) begin
        x_ff [0] <= 0;
        x_ff [1] <= 0;
        x_ff [2] <= 0;
        x_ff [3] <= 0;
        end
     else begin
        x_ff [0] <= data_i [7:0];
        x_ff [1] <= data_i [15:8];
        x_ff [2] <= data_i [23:16];
        x_ff [3] <= data_i [31:24];
        end
        
        end
        
     //линии задержки
 always_ff @(posedge clk_i or posedge rst_i) begin
    
    if (rst_i) 
        x2_ff  <= 0;
    else 
        x2_ff  <=  x_ff [1] ;
       end
       
       
 always_ff @(posedge clk_i or posedge rst_i) begin
    
    if (rst_i) begin
        x3_ff [0] <= 0;
        x3_ff [1] <= 0;
        end
    else begin
        x3_ff [0]  <=  x_ff [2] ;
        x3_ff [1]  <=  x3_ff [0] ;
       end
   end
       
  always_ff @(posedge clk_i or posedge rst_i) begin
    
    if (rst_i) begin
        x4_ff [0] <= 0;
        x4_ff [1] <= 0;
        x4_ff [2] <= 0;
        end
    else begin
        x4_ff [0]  <=  x_ff [3] ;
        x4_ff [1]  <=  x4_ff [0] ;
        x4_ff [2]  <=  x4_ff [1] ;
       end  
  end     
       
                 
        
        
        
      

 // передача данных на систолический массив
assign x [0] = x_ff [0];
assign x [1] = x2_ff   ;
assign x [2] = x3_ff [1];
assign x [3] = x4_ff [2];

assign valid [0] = valid_ff [0];
assign valid [1] = valid_ff [1];
assign valid [2] = valid_ff [2];
assign valid [3] = valid_ff [3];

 
//output/////////
logic valid1_y [4:0];
logic valid2_y [3:0];
logic valid3_y [2:0];
logic valid4_y [1:0];
  
assign valid1_y [0] = valid_ff [4];
assign valid2_y [0] = valid_ff [5];
assign valid3_y [0] = valid_ff [6];
assign valid4_y [0] = valid_ff [7];



logic [7:0] y1_ff [3:0];
logic [7:0] y2_ff [2:0];   
logic [7:0] y3_ff [1:0];
logic [7:0] y4_ff;
// сигналы валидности для выходных данных ситолического массива
always_ff @(posedge clk_i or posedge rst_i) begin   
     if (rst_i) begin 
     valid1_y [1] <= 0;
     valid1_y [2] <= 0;
     valid1_y [3] <= 0;
     valid1_y [4] <= 0;
     end
     
     else begin 
     valid1_y [1] <= valid1_y [0];
     valid1_y [2] <= valid1_y [1];
     valid1_y [3] <= valid1_y [2];
     valid1_y [4] <= valid1_y [3];
    
     end
end

always_ff @(posedge clk_i or posedge rst_i) begin   
     if (rst_i) begin 
     valid2_y [1] <= 0;
     valid2_y [2] <= 0;
     valid2_y [3] <= 0;
     end
     
     else begin 
     valid2_y [1] <= valid2_y [0];
     valid2_y [2] <= valid2_y [1];
     valid2_y [3] <= valid2_y [2];
    
     end
end

always_ff @(posedge clk_i or posedge rst_i) begin   
     if (rst_i) begin 
     valid3_y [1] <= 0;
     valid3_y [2] <= 0;
     end
     
     else begin 
     valid3_y [1] <= valid3_y [0];
     valid3_y [2] <= valid3_y [1];
    
     end
end


always_ff @(posedge clk_i or posedge rst_i) begin   
     if (rst_i) begin 
     valid4_y [1] <= 0;
     end
     
     else begin 
     valid4_y [1] <= valid4_y [0];
    
     end
end





//y1
always_ff @(posedge clk_i or posedge rst_i) begin   
     if (rst_i) begin 
     y1_ff [0] <= 0;
     y1_ff [1] <= 0;
     y1_ff [2] <= 0;
     y1_ff [3] <= 0;
     end
     
     else begin 
     if (valid1_y [0]) y1_ff [0] <= y1 [7:0];
     if (valid1_y [1]) y1_ff [1] <= y1_ff [0];
     if (valid1_y [2]) y1_ff [2] <= y1_ff [1];
     if (valid1_y [3]) y1_ff [3] <= y1_ff [2];
     end
end
//y2
always_ff @(posedge clk_i or posedge rst_i) begin   
     if (rst_i) begin 
     y2_ff [0] <= 0;
     y2_ff [1] <= 0;
     y2_ff [2] <= 0;
     end
     
     else begin 
     if (valid2_y [0]) y2_ff [0] <= y2 [7:0];
     if (valid2_y [1]) y2_ff [1] <= y2_ff [0];
     if (valid2_y [2]) y2_ff [2] <= y2_ff [1];        
     end
end
//y3
always_ff @(posedge clk_i or posedge rst_i) begin   
     if (rst_i) begin 
     y3_ff [0] <= 0;
     y3_ff [1] <= 0;
     
     end
     
     else begin 
     if (valid3_y [0]) y3_ff [0] <= y3 [7:0];
     if (valid3_y [1]) y3_ff [1] <= y3_ff [0];
     
     end
end


always_ff @(posedge clk_i or posedge rst_i) begin   
     if (rst_i) begin 
     y4_ff  <= 0;
     
     
     end
     
     else begin 
     if (valid4_y [0] ) y4_ff  <= y4 [7:0];
     
     
     end
end

logic [31:0] syst_data_ff;
logic       syst_valid_ff;

always_ff @(posedge clk_i or posedge rst_i) begin   
     if (rst_i)   syst_valid_ff  <= 0;
     
     else  syst_valid_ff <= valid4_y [1];
     
     
 end
 // выходыне регистры
 always_ff @(posedge clk_i or posedge rst_i) begin   
     if (rst_i) begin 
        syst_data_ff <=0;
     end
     
     else begin 
     if (valid1_y [4]) syst_data_ff [7:0]   <= y1_ff [3];
     if (valid2_y [3]) syst_data_ff [15:8]  <= y2_ff [2];
     if (valid3_y [2]) syst_data_ff [23:16] <= y3_ff [1];
     if (valid4_y [1]) syst_data_ff [31:24] <= y4_ff ;
     end
end
 
 assign data_o  = syst_data_ff;
 assign valid_o = syst_valid_ff;
 

      
         
  
  
endmodule
