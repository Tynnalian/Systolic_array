`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 29.05.2024 19:30:07
// Design Name:
// Module Name: APB_tb
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


module matrix_mult();

logic        p_clk_i;
logic        p_rst_i;
logic [31:0] p_dat_i;
logic [31:0] p_dat_o;
logic        p_enable_i;
logic        p_sel_i;
logic        p_we_i;
logic [31:0] p_adr_i;
logic        p_ready;

syst_APB
dut_syst_APB
(
  .p_clk_i    (p_clk_i),
  .p_rst_i    (p_rst_i),
  .p_dat_i    (p_dat_i),
  .p_dat_o    (p_dat_o),
  .p_enable_i (p_enable_i),
  .p_sel_i    (p_sel_i),
  .p_we_i     (p_we_i),
  .p_adr_i    (p_adr_i),
  .p_ready    (p_ready)
);


task write_register; // Название task
  input [31:0] reg_addr; // Параметры передаваемые в task, в нашем случае адрес и данные
  input [31:0] reg_data;

  begin
    @ (posedge p_clk_i); // Ожидаем один такт

    // Формируем посылку согласно документации на APB
    p_adr_i    = reg_addr; // Выставляем значения на шины адреса и данных
    p_dat_i    = reg_data;
    p_enable_i = 0;
    p_sel_i    = 1;
    p_we_i     = 1;

    @ (posedge p_clk_i); // Ожидаем один такт

    p_enable_i = 1;

    wait (p_ready); // Ожидаем появление сигнала p_ready

    // Вывод информации о совершенной операции
   // $display("(%0t) Writing register [%0d] = 0x%0x", $time, p_adr_i, reg_data);
    @ (posedge p_clk_i);

    // Возвращаем сигналы в исходное состояние
    p_adr_i    = 'hz;
    p_dat_i    = 'hz;
    p_enable_i = 0;
    p_sel_i    = 0;
    p_we_i     = 'hz;
  end
endtask

task matrix_4x4_multiplication;
  input [31:0] raw_1;
  input [31:0] raw_2;
  input [31:0] raw_3;
  input [31:0] raw_4;
  input [31:0] string_1;
  input [31:0] string_2;
  input [31:0] string_3;
  input [31:0] string_4;
    logic [31:0] raw_1_r;
    logic [31:0] raw_2_r;
    logic [31:0] raw_3_r;
    logic [31:0] raw_4_r;
    logic [31:0] col_1_r;
    logic [31:0] col_2_r;
    logic [31:0] col_3_r;
    logic [31:0] col_4_r;

    raw_1_r = {raw_1 [7:0], raw_1 [15:8],raw_1 [23:16],raw_1 [31:24]};
    raw_2_r = {raw_2 [7:0], raw_2 [15:8],raw_2 [23:16],raw_2 [31:24]};
    raw_3_r = {raw_3 [7:0], raw_3 [15:8],raw_3 [23:16],raw_3 [31:24]};
    raw_4_r = {raw_4 [7:0], raw_4 [15:8],raw_4 [23:16],raw_4 [31:24]};

    col_1_r = {string_4 [31:24] ,string_3 [31:24],string_2 [31:24] ,string_1 [31:24]};
    col_2_r = {string_4 [23:16] ,string_3 [23:16],string_2 [23:16] ,string_1 [23:16]};
    col_3_r = {string_4 [15:8] ,string_3 [15:8],string_2 [15:8] ,string_1 [15:8]};
    col_4_r = {string_4 [7:0] ,string_3 [7:0],string_2 [7:0] ,string_1 [7:0]};

  begin
  ///Matrix of weights;
    write_register(32'd8, col_1_r);
     #50 ;
    write_register(32'd12, col_2_r);
     #50 ;
    write_register(32'd16, col_3_r);
     #50 ;
    write_register(32'd20, col_4_r);
     #50 ;

     write_register(32'd0, raw_1_r);
     #50 ;
    write_register(32'd0, raw_2_r);
     #50 ;
    write_register(32'd0, raw_3_r);
     #50 ;
    write_register(32'd0, raw_4_r);
     #50 ;
     end
endtask


task read_register;
  input [31:0] reg_addr;
  begin
    @ (posedge p_clk_i);

    p_adr_i    = reg_addr;
    p_enable_i = 0;
    p_sel_i    = 1;
    p_we_i     = 0;

    @ (posedge p_clk_i);

    p_enable_i = 1;

    wait (p_ready);

   // $display("(%0t) Reading register [%0d] = 0x%0x", $time, p_adr_i, p_dat_o);

    @ (posedge p_clk_i);

    p_adr_i    = 'hz;
    p_enable_i = 0;
    p_sel_i    = 0;
    p_we_i     = 'hz;
  end
endtask


initial
begin
  p_clk_i=0;
  forever #50 p_clk_i = ~p_clk_i; // Сигнал инвертируется каждые 50нс
end

initial
begin
  p_dat_i    = 'hz;
  p_enable_i = 0;
  p_sel_i    = 0;
  p_we_i     = 'hz;
  p_adr_i    = 'hz;
  p_rst_i    = 1;
  #200
  p_rst_i    = 0; // Запись #200 обозначает что смена значения сигнала сброса произойдет через 200нс.
end

initial
begin
  wait(!p_rst_i)

    //////// First multiplication////////////
    // Matrix of Weights
    matrix_4x4_multiplication (
    32'h07_04_04_03,
    32'h01_05_05_01,
    32'h07_00_02_04,
    32'h01_02_04_02,
 //        x
    32'h01_04_05_06,
    32'h05_04_08_00,
    32'h01_06_02_07,
    32'h02_03_01_00
    );
// SECOND multiplication
    matrix_4x4_multiplication (
    32'h01_05_06_02,
    32'h02_07_08_09,
    32'h05_04_08_01,
    32'h00_05_08_03,
 //        x
    32'h07_04_04_06,
    32'h05_06_02_03,
    32'h02_05_03_04,
    32'h08_01_05_03
    );
//   THIRD multiplication
    matrix_4x4_multiplication (
    32'h01_05_04_07,
    32'h02_05_08_01,
    32'h07_06_05_02,
    32'h01_07_04_02,
 //        x
    32'h01_05_02_06,
    32'h03_01_08_00,
    32'h01_06_03_07,
    32'h02_04_01_00
    );


  #1200 repeat (12) begin
  read_register(32'd4);
   #70;
  end
  #100
  $stop();
end

initial
begin
#(16250) $display("FIRST_MULTIPLICATION");
         $display("7 4 4 3   1 4 5 6");
         $display("1 5 5 1 X 5 4 8 0");
         $display("7 0 2 4   1 6 2 7");
         $display("1 2 4 2   2 3 1 0");

if((p_dat_o [7:0] == 8'd37) & (p_dat_o [15:8] == 8'd77) &
            (p_dat_o [23:16] == 8'd78) & (p_dat_o [31:24] == 8'd70))
             $display("FIRST RAW IS CORRECT: %0d %0d %0d %0d", p_dat_o [7:0],
             p_dat_o [15:8], p_dat_o [23:16], p_dat_o [31:24]);
         else $error("FIRST RAW IS INCORRECT EXPECTED:37 77 78 70 REAL: %0d %0d %0d %0d",
          p_dat_o [7:0], p_dat_o [15:8], p_dat_o [23:16], p_dat_o [31:24]);

#(600)   if((p_dat_o [7:0] == 'd33) & (p_dat_o [15:8] == 'd57) &
            (p_dat_o [23:16] == 'd56) & (p_dat_o [31:24] == 'd41))
             $display("SECOND RAW IS CORRECT:%0d %0d %0d %0d", p_dat_o [7:0],
             p_dat_o [15:8], p_dat_o [23:16], p_dat_o [31:24]);
         else $error("SECOND RAW IS INCORRECT EXPECTED:33 57 56 78 REAL: %0d %0d %0d %0d",
          p_dat_o [7:0], p_dat_o [15:8], p_dat_o [23:16], p_dat_o [31:24]);

#(600)   if((p_dat_o [7:0] == 'd17) & (p_dat_o [15:8] == 'd52) &
            (p_dat_o [23:16] == 'd43) & (p_dat_o [31:24] == 'd56))
             $display("THIRD RAW IS CORRECT: %0d %0d %0d %0d", p_dat_o [7:0],
             p_dat_o [15:8], p_dat_o [23:16], p_dat_o [31:24]);
         else $error("THIRD RAW IS INCORRECT EXPECTED:17 52 43 56 REAL: %0d %0d %0d %0d",
          p_dat_o [7:0], p_dat_o [15:8], p_dat_o [23:16], p_dat_o [31:24]);
#(600)   if((p_dat_o [7:0] == 'd19) & (p_dat_o [15:8] == 'd42) &
            (p_dat_o [23:16] == 'd31) & (p_dat_o [31:24] == 'd34))
          $display("FORTH RAW IS CORRECT: %0d %0d %0d %0d", p_dat_o [7:0],
             p_dat_o [15:8], p_dat_o [23:16], p_dat_o [31:24]);
         else $error("FORTH RAW IS INCORRECT EXPECTED:19 42 31 34 REAL: %0d %0d %0d %0d",
         p_dat_o [7:0], p_dat_o [15:8], p_dat_o [23:16], p_dat_o [31:24]);

#(600)  $display("SECOND_MULTIPLICATION");
         $display("1 5 6 2   7 4 4 6");
         $display("2 7 8 9 X 5 6 2 3");
         $display("5 4 8 1   2 5 3 4");
         $display("0 5 8 3   8 1 5 3");

if((p_dat_o [7:0] == 8'd60) & (p_dat_o [15:8] == 8'd66) &
            (p_dat_o [23:16] == 8'd42) & (p_dat_o [31:24] == 8'd51))
             $display("FIRST RAW IS CORRECT: %0d %0d %0d %0d", p_dat_o [7:0],
             p_dat_o [15:8], p_dat_o [23:16], p_dat_o [31:24]);
         else $error("FIRST RAW IS INCORRECT EXPECTED:60 66 42 51 REAL: %0d %0d %0d %0d",
          p_dat_o [7:0], p_dat_o [15:8], p_dat_o [23:16], p_dat_o [31:24]);

#(600)   if((p_dat_o [7:0] == 'd137) & (p_dat_o [15:8] == 'd99) &
            (p_dat_o [23:16] == 'd91) & (p_dat_o [31:24] == 'd92))
             $display("SECOND RAW IS CORRECT:%0d %0d %0d %0d", p_dat_o [7:0],
             p_dat_o [15:8], p_dat_o [23:16], p_dat_o [31:24]);
         else $error("SECOND RAW IS INCORRECT EXPECTED:137 99 91 92 REAL: %0d %0d %0d %0d",
          p_dat_o [7:0], p_dat_o [15:8], p_dat_o [23:16], p_dat_o [31:24]);

#(600)   if((p_dat_o [7:0] == 'd79) & (p_dat_o [15:8] == 'd85) &
            (p_dat_o [23:16] == 'd57) & (p_dat_o [31:24] == 'd77))
             $display("THIRD RAW IS CORRECT: %0d %0d %0d %0d", p_dat_o [7:0],
             p_dat_o [15:8], p_dat_o [23:16], p_dat_o [31:24]);
         else $error("THIRD RAW IS INCORRECT EXPECTED:79 85 57 77 REAL: %0d %0d %0d %0d",
          p_dat_o [7:0], p_dat_o [15:8], p_dat_o [23:16], p_dat_o [31:24]);
#(600)   if((p_dat_o [7:0] == 'd65) & (p_dat_o [15:8] == 'd73) &
            (p_dat_o [23:16] == 'd49) & (p_dat_o [31:24] == 'd56))
          $display("FORTH RAW IS CORRECT: %0d %0d %0d %0d", p_dat_o [7:0],
             p_dat_o [15:8], p_dat_o [23:16], p_dat_o [31:24]);
         else $error("FORTH RAW IS INCORRECT EXPECTED:65 73 49 56 REAL: %0d %0d %0d %0d",
         p_dat_o [7:0], p_dat_o [15:8], p_dat_o [23:16], p_dat_o [31:24]);


#(600)  $display("THIRD_MULTIPLICATION");
         $display("1 5 4 7   1 5 2 6");
         $display("2 5 8 1 X 3 1 8 0");
         $display("7 6 5 2   1 6 3 7");
         $display("1 7 4 2   2 4 1 0");

if((p_dat_o [7:0] == 8'd34) & (p_dat_o [15:8] == 8'd62) &
            (p_dat_o [23:16] == 8'd61) & (p_dat_o [31:24] == 8'd34))
             $display("FIRST RAW IS CORRECT: %0d %0d %0d %0d", p_dat_o [7:0],
             p_dat_o [15:8], p_dat_o [23:16], p_dat_o [31:24]);
         else $error("FIRST RAW IS INCORRECT EXPECTED:60 66 42 51 REAL: %0d %0d %0d %0d",
          p_dat_o [7:0], p_dat_o [15:8], p_dat_o [23:16], p_dat_o [31:24]);

#(600)   if((p_dat_o [7:0] == 'd27) & (p_dat_o [15:8] == 'd67) &
            (p_dat_o [23:16] == 'd69) & (p_dat_o [31:24] == 'd68))
             $display("SECOND RAW IS CORRECT:%0d %0d %0d %0d", p_dat_o [7:0],
             p_dat_o [15:8], p_dat_o [23:16], p_dat_o [31:24]);
         else $error("SECOND RAW IS INCORRECT EXPECTED:137 99 91 92 REAL: %0d %0d %0d %0d",
          p_dat_o [7:0], p_dat_o [15:8], p_dat_o [23:16], p_dat_o [31:24]);

#(600)   if((p_dat_o [7:0] == 'd34) & (p_dat_o [15:8] == 'd79) &
            (p_dat_o [23:16] == 'd79) & (p_dat_o [31:24] == 'd77))
             $display("THIRD RAW IS CORRECT: %0d %0d %0d %0d", p_dat_o [7:0],
             p_dat_o [15:8], p_dat_o [23:16], p_dat_o [31:24]);
         else $error("THIRD RAW IS INCORRECT EXPECTED:79 85 57 77 REAL: %0d %0d %0d %0d",
          p_dat_o [7:0], p_dat_o [15:8], p_dat_o [23:16], p_dat_o [31:24]);
#(600)   if((p_dat_o [7:0] == 'd30) & (p_dat_o [15:8] == 'd44) &
            (p_dat_o [23:16] == 'd72) & (p_dat_o [31:24] == 'd34))
          $display("FORTH RAW IS CORRECT: %0d %0d %0d %0d", p_dat_o [7:0],
             p_dat_o [15:8], p_dat_o [23:16], p_dat_o [31:24]);
         else $error("FORTH RAW IS INCORRECT EXPECTED:65 73 49 56 REAL: %0d %0d %0d %0d",
         p_dat_o [7:0], p_dat_o [15:8], p_dat_o [23:16], p_dat_o [31:24]);
end

endmodule
