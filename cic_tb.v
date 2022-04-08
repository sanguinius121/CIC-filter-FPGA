`timescale 1ns/1ps
module cic32_tb
    (

    );

    reg r_clk_in_high = 1'b0;
    reg r_reset;
    reg [7:0] r_signal_in;
    wire w_clk_out_low;
    wire [9:0] w_signal;

    cic32 UUT
        (
            .i_clk_high(r_clk_in_high),
            .i_reset(r_reset),
            .i_signal(r_signal_in),
            .o_clk_low(w_clk_out_low),
            .o_signal(w_signal)
        );
    always r_clk_in_high <= !r_clk_in_high;
    initial 
        begin
            r_reset <= 1'b1;
            r_signal_in <= 8'b0;
            #100
            r_reset <= 1'b0;
            r_signal_in <= 8'd0;
            #10;
        end
endmodule