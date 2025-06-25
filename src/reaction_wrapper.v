module reaction_wrapper (
    input  wire [7:0] ui_in,     // general inputs
    output wire [7:0] uo_out,    // general outputs
    input  wire [7:0] uio_in,    // not used
    output wire [7:0] uio_out,   // anode signals
    output wire [7:0] uio_oe,    // drive anode signals
    input  wire       ena,       // always 1
    input  wire       clk,       // system clock
    input  wire       rst_n      // active-low reset
);

    // Active-high reset
    wire reset = ~rst_n;

    // Map UI buttons
    wire start_btn = ui_in[0];
    wire react_btn = ui_in[1];

    // Outputs
    wire led;
    wire [6:0] seg;
    wire [3:0] an;

    // Instantiate your main reaction time tester
    tt_um_DelosReyesJordan_ReactionTimeTest dut (
        .clk(clk),
        .start_btn(start_btn),
        .react_btn(react_btn),
        .reset_btn(reset),
        .led(led),
        .seg(seg),
        .an(an)
    );

    // Output LED on uo_out[0]
    assign uo_out[0] = led;

    // Output 7-segment segments on uo_out[7:1]
    assign uo_out[7:1] = seg;

    // Output anode control on uio_out[3:0]
    assign uio_out[3:0] = an;
    assign uio_oe[3:0]  = 4'b1111;

    // Disable unused upper 4 uio pins
    assign uio_out[7:4] = 4'b0000;
    assign uio_oe[7:4]  = 4'b0000;

endmodule
