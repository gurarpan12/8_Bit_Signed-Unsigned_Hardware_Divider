`timescale 1ns / 1ps

module tb_divider_top();

  reg clk;
  reg start;
  reg rst_n;
  reg signed [7:0] Dividend;
  reg signed [7:0] Divisor;
  reg is_signed;

  wire signed [7:0] signed_quotient;
  wire signed [7:0] signed_remainder;
  wire zero_error;
  wire ready;

  divider_top dut (
    .clk(clk),
    .start(start),
    .rst_n(rst_n),
    .Dividend(Dividend),
    .Divisor(Divisor),
    .is_signed(is_signed),
    .signed_quotient(signed_quotient),
    .signed_remainder(signed_remainder),
    .zero_error(zero_error),
    .ready(ready)
  );

  always #5 clk = ~clk;

  task push_start_button;
  begin
    start = 1;
    @(posedge clk);
    @(posedge clk);
    start = 0;
  end
  endtask

  task run_test(
    input [7:0] num, 
    input [7:0] den, 
    input sign_flag
  );
  begin
    Dividend = num;
    Divisor = den;
    is_signed = sign_flag;
    
    push_start_button();
    
    wait(ready || zero_error);
    #10;
  end
  endtask

  initial begin
    $dumpfile("divider_waveforms.vcd"); 
    $dumpvars(0, tb_divider_top);

  
    $monitor("Time: %0t | rst_n: %b | start: %b | Dividend: %0d | Divisor: %0d | ready: %b | Quot: %0d | Rem: %0d | Z_err: %b", 
             $time, rst_n, start, Dividend, Divisor, ready, signed_quotient, signed_remainder, zero_error);

    clk = 0;
    start = 0;
    rst_n = 0;
    Dividend = 0;
    Divisor = 0;
    is_signed = 0;

    #20;
    rst_n = 1;
    #10;

    run_test(8'd100, 8'd5, 1'b0);
    run_test(8'd100, 8'd3, 1'b0);
    run_test(8'd5, 8'd10, 1'b0);
    run_test(8'd120, -8'd4, 1'b1);
    run_test(-8'd50, 8'd5, 1'b1);
    run_test(-8'd80, -8'd3, 1'b1);
    run_test(8'd127, 8'd1, 1'b1);
    run_test(-8'd128, 8'd1, 1'b1);
    run_test(8'd50, 8'd0, 1'b0);
    run_test(-8'd50, 8'd0, 1'b1);

    #50;
    $finish;
  end

endmodule
