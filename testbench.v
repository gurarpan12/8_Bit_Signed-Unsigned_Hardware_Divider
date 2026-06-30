`timescale 1s/1ms

module tb_Divider_top;
  reg clk;
  reg start;
  reg rst_n;
  reg [7:0] Dividend;
  reg [7:0] Divisor;
  reg is_signed;
  wire [7:0] signed_quotient;
  wire [7:0] signed_remainder;
  wire zero_error;
  wire ready;

  divider_top dut(
    .clk (clk),
    .start (start),
    .rst_n (rst_n),
    .Dividend (Dividend),
    .Divisor (Divisor),
    .is_signed (is_signed),
    .signed_quotient (signed_quotient),
    .signed_remainder (signed_remainder),
    .zero_error (zero_error),
    .ready (ready)
  );
  
  always begin
    #0.5 clk=~clk;
  end
  
  initial begin
    clk = 1'b0;
    rst_n = 0;
    Dividend = 8'b0;
    Divisor = 8'b0;
    is_signed = 0;
    start=0;
    
    #1 rst_n = 1;
    #1 start = 1; Dividend = -8'd16; Divisor = 8'd2; is_signed =1;
    #1 start = 0;
    #15 start = 1; Dividend = 8'd16; Divisor = 8'd0;
    #1 start = 0;
    #15 start = 1; Dividend = 8'd0; Divisor = 8'd0;
    #1 start = 0;
    #15 start = 1; Dividend = -8'd121; Divisor = 8'd19;
    #1 start = 0;
    #100 $finish;
  end
  
  initial begin
    $monitor("Time: %0.1f s | rst_n: %b | Start: %b | Dividend: %b | Divisor: %b | is_signed: %b | Q: %b | R: %b | zero_error: %b | ready: %b", $realtime, rst_n, start, Dividend, Divisor, is_signed, signed_quotient, signed_remainder, zero_error, ready);
  end
endmodule
