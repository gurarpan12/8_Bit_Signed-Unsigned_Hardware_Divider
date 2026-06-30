module divider_top(
  input wire clk,
  input wire start,
  input wire rst_n,
  input wire [7:0] Dividend,
  input wire [7:0] Divisor,
  input wire is_signed,
  output wire [7:0] signed_quotient,
  output wire [7:0] signed_remainder,
  output wire zero_error,
  output wire ready
);
  
  wire [7:0] signed_Dividend;
  wire [7:0] signed_Divisor;
  wire Dividend_sign;
  wire Divisor_sign;
  
  wire [7:0] quotient;
  wire [7:0] remainder;
  wire Z_error;
  
  input_sign inp(
    .Dividend (Dividend),
    .Divisor (Divisor),
    .is_signed (is_signed),
    .signed_Dividend (signed_Dividend),
    .signed_Divisor (signed_Divisor),
    .Dividend_sign (Dividend_sign),
    .Divisor_sign (Divisor_sign)
  );
  
  divider div(
    .clk (clk),
    .start (start),
    .rst_n (rst_n),
    .signed_Dividend (signed_Dividend),
    .signed_Divisor (signed_Divisor),
    .ready (ready),
    .quotient (quotient),
    .remainder (remainder),
    .Z_error (Z_error)
  );
  
  output_sign out(
    .quotient (quotient),
    .remainder (remainder),
    .Dividend_sign (Dividend_sign),
    .Divisor_sign (Divisor_sign),
    .is_signed (is_signed),
    .Z_error (Z_error),
    .signed_quotient (signed_quotient),
    .signed_remainder (signed_remainder),
    .zero_error (zero_error)
  );
  
endmodule
