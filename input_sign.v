module input_sign(
  input wire [7:0] Dividend,
  input wire [7:0] Divisor,
  input wire is_signed,
  output wire [7:0] signed_Dividend,
  output wire [7:0] signed_Divisor,
  output wire Dividend_sign,
  output wire Divisor_sign
);
  
  assign Dividend_sign = is_signed ? Dividend[7] : 1'b0;
  assign Divisor_sign = is_signed ? Divisor[7] : 1'b0;
  
  assign signed_Dividend = Dividend_sign ? (~Dividend + 8'b1) : Dividend;
  assign signed_Divisor = Divisor_sign ? (~Divisor + 8'b1) : Divisor;  
  
endmodule
