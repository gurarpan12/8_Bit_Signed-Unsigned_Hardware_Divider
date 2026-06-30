module divider(
  input wire clk,
  input wire start,
  input wire rst_n,
  input wire [7:0] signed_Dividend,
  input wire [7:0] signed_Divisor,
  output reg ready,
  output reg [7:0] quotient,
  output reg [7:0] remainder,
  output reg Z_error
);
  
  localparam IDLE    = 2'b00;
  localparam DIVIDE  = 2'b01;
  localparam CORRECT = 2'b10;
  localparam DONE    = 2'b11;
  
  reg [1:0]  current_state, next_state; 
  reg [15:0] A_D;       
  reg [7:0]  B;         
  reg [2:0]  counter;  
  
  wire is_zero;
  wire timer_done;
  wire [8:0] sub_result;
  
  assign sub_result = {1'b0, A_D[14:7]} - {1'b0, B};
  assign timer_done = (counter == 3'b111);
  assign is_zero    = ~|signed_Divisor;
  
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
      current_state <= IDLE;
    else 
      current_state <= next_state;
  end
  
  always @(*) begin
    case (current_state)
      IDLE: begin
        if (start) begin
          if (is_zero) next_state = DONE;   
          else next_state = DIVIDE;
        end
        else next_state = IDLE;
      end
      DIVIDE: begin
        if (timer_done) next_state = CORRECT;
        else next_state = DIVIDE;
      end
      CORRECT: begin
        next_state = DONE;
      end
      DONE: begin 
        next_state = IDLE;
      end
      default: next_state = IDLE;
    endcase
  end
  
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      A_D <= 16'b0;
      B <= 8'b0;
      counter <= 3'b0;
      quotient <= 8'b0;
      remainder <= 8'b0;
      ready <= 1'b0;
      Z_error <= 1'b0;
    end 
    else begin
      case (current_state)
        IDLE: begin
          ready <= 1'b0;
          counter <= 3'b0;
          if (start) begin
            if (is_zero) begin
              Z_error <= 1'b1;
            end 
            else begin
              Z_error <= 1'b0;
              B <= signed_Divisor;
              A_D <= {8'b0, signed_Dividend};
            end
          end
        end
        DIVIDE: begin
          counter <= counter + 3'b1;
          if (sub_result[8] == 1'b0) begin
            A_D <= {sub_result[7:0], A_D[6:0], 1'b1};
          end 
          else begin 
            A_D <= {A_D[14:0], 1'b0};
          end
        end
        CORRECT: begin
          quotient  <= A_D[7:0];
          remainder <= A_D[15:8];
        end
        DONE: begin
          ready <= 1'b1;
        end
      endcase
    end
  end
  
endmodule
