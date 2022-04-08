// Company : CKT
// Engineer : Nguyen Anh Tuan
// Module : CIC filter
// Date : 07/4/2022
// Descrisption: CIC Decimation filter with factor of 32. This example base on example of Uwe.Meyer - Bease 
// Books: Digital Signal Processing , Page 695
// CIC Decimation includes 2 sectors: Intergrater and Comb
// Decimation factor M = 32 (decrease the Fs 32 times)
// Number of Intergrator stages: 3
// Number of Comb stages: 3
// Signal input bit width: 8 bits
// signal output bit width : 10 bits
module cic32
    (
        input i_clk_high,
        input i_reset,
        input [7:0] i_signal,
        output reg o_clk_low,
        output [9:0] o_signal
    );

    localparam hold   = 1'b0;
    localparam sample = 1'b1;
    reg [1:0] r_main_ST;
    reg [4:0] r_counter;
    reg [7:0] r_signal_in;
    reg [25:0] r_intergrator_0;
    reg [20:0] r_intergrator_1;
    reg [15:0] r_intergrator_2;
    reg [13:0] r_intergrator_2_decimation_1;
    reg [13:0] r_intergrator_2_decimation_2;
    reg [13:0] r_comb_0;
    reg [13:0] r_comb_1;
    reg [12:0] r_comb_1_decimation_1;
    reg [12:0] r_comb_1_decimation_2;
    reg [12:0] r_comb_2;
    reg [11:0] r_comb_2_decimation_1;
    reg [11:0] r_comb_2_decimation_2;
    reg [11:0] r_comb_3;

    always @(posedge i_clk_high or posedge i_reset)
        begin
            if(i_reset)
                begin
                    r_counter <= 5'b0;
                    r_main_ST <= hold;
                    o_clk_low <= 1'b0;
                end
            else
                begin
                    if (r_counter == 5'd31)
                        begin
                            r_counter <= 5'b0;
                            r_main_ST <= sample;
                            o_clk_low <= 1'b1;
                        end
                    else
                        begin
                            r_counter <= r_counter + 1;
                            r_main_ST <= hold;
                            o_clk_low <= 1'b0;
                        end
                    // done create new low speed clock sample and state machine for sampling
                end
        end
    
    // always block for intergrator sections
    always @(posedge i_clk_high)
        begin
            r_signal_in     <= i_signal;
            r_intergrator_0 <= r_intergrator_0 + r_signal_in;
            r_intergrator_1 <= r_intergrator_1 + r_intergrator_0[25:5];
            r_intergrator_2 <= r_intergrator_2 + r_intergrator_1[20:5];
        end
    
    // always block for 3 comb sections
    always @(posedge i_clk_high)
        begin
            if (r_main_ST == sample)
                begin
                    r_comb_0 <= r_intergrator_2[15:2];
                    r_intergrator_2_decimation_1 <= r_comb_0;
                    r_intergrator_2_decimation_2 <= r_intergrator_2_decimation_1;
                    r_comb_1 <= r_comb_0 - r_intergrator_2_decimation_2;
                    r_comb_1_decimation_1 <= r_comb_1[13:1];
                    r_comb_1_decimation_2 <= r_comb_1_decimation_1;
                    r_comb_2 <= r_comb_1[13:1] - r_comb_1_decimation_2;
                    r_comb_2_decimation_1 <= r_comb_2[12:1];
                    r_comb_2_decimation_2 <= r_comb_2_decimation_1;
                    r_comb_3 <= r_comb_2 - r_comb_2_decimation_2;
                end
        end

    assign o_signal = r_comb_3[11:2];
endmodule