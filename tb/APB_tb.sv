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


module APB_tb();

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


task write_register; // �������� task
  input [31:0] reg_addr; // ��������� ������������ � task, � ����� ������ ����� � ������
  input [31:0] reg_data;

  begin
    @ (posedge p_clk_i); // ������� ���� ����

    // ��������� ������� �������� ������������ �� APB
    p_adr_i    = reg_addr; // ���������� �������� �� ���� ������ � ������
    p_dat_i    = reg_data;
    p_enable_i = 0;
    p_sel_i    = 1;
    p_we_i     = 1;

    @ (posedge p_clk_i); // ������� ���� ����

    p_enable_i = 1;

    wait (p_ready); // ������� ��������� ������� p_ready

    // ����� ���������� � ����������� ��������
    $display("(%0t) Writing register [%0d] = 0x%0x", $time, p_adr_i, reg_data);
    @ (posedge p_clk_i);

    // ���������� ������� � �������� ���������
    p_adr_i    = 'hz;
    p_dat_i    = 'hz;
    p_enable_i = 0;
    p_sel_i    = 0;
    p_we_i     = 'hz;
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

    $display("(%0t) Reading register [%0d] = 0x%0x", $time, p_adr_i, p_dat_o);

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
  forever #50 p_clk_i = ~p_clk_i; // ������ ������������� ������ 50��
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
  p_rst_i    = 0; // ������ #200 ���������� ��� ����� �������� ������� ������ ���������� ����� 200��.
end

initial
begin
  wait(!p_rst_i)
   repeat(7) begin
   write_register(32'd0, $urandom);
     #50 ;
   end
  
  #1200 repeat (7) begin
  read_register(32'd4);
   #70;
  end
  #100
  $stop();
end



endmodule
