module synchronizer (
  input wire clk,
  input wire rst_n,
  input wire button_in,     
  output wire start_pulse    
);

    reg sync_ff1; 
    reg sync_ff2; 
    reg history_ff3; 

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync_ff1    <= 1'b0;
            sync_ff2    <= 1'b0;
            history_ff3 <= 1'b0;
        end else begin
            sync_ff1    <= button_in;
            sync_ff2    <= sync_ff1;  
            history_ff3 <= sync_ff2; 
        end
    end
  
    assign start_pulse = sync_ff2 & ~history_ff3;

endmodule
