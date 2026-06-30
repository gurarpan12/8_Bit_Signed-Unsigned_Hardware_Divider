module output_sign(
  input wire[7:0] quotient,
  input wire[7:0] remainder,
  input wire Dividend_sign,
  input wire Divisor_sign,
  input wire is_signed,
  input wire Z_error,
  output wire [7:0] signed_quotient,
  output wire [7:0] signed_remainder,
  output wire zero_error
);
  
  wire final_quotient_sign;
  wire final_remainder_sign;
  wire [7:0] correct_quotient;
  wire [7:0] correct_remainder;
  
  assign final_quotient_sign = is_signed ? (Dividend_sign ^ Divisor_sign) : 1'b0;
  assign final_remainder_sign = is_signed ? Dividend_sign : 1'b0;
  
  
  assign correct_quotient = final_quotient_sign ? (~quotient + 8'b1) : quotient;
  assign correct_remainder = final_remainder_sign ? (~remainder + 8'b1) :  remainder;
  
  assign signed_quotient = Z_error ? 8'b0 : correct_quotient;
  assign signed_remainder = Z_error ? 8'b0 : correct_remainder;
  
  assign zero_error = Z_error;
  
endmodule
