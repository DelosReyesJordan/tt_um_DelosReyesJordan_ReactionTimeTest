module reaction_time_top(
    input clk,
    input start_btn,
    input react_btn,
    input reset_btn,
    output led,
    output [6:0] seg,
    output [3:0] an
);
    wire delay_done, start_timer, stop_timer, show_error, done;
    wire [13:0] ms_time;

    reaction_fsm fsm(
        .clk(clk),
        .reset(reset_btn),
        .start_btn(start_btn),
        .react_btn(react_btn),
        .delay_done(delay_done),
        .elapsed_time(ms_time),
        .led(led),
        .start_timer(start_timer),
        .stop_timer(stop_timer),
        .show_error(show_error),
        .done(done)
    );

    random_delay delay(
        .clk(clk),
        .reset(reset_btn),
        .start(fsm.state == fsm.WAIT),
        .done(delay_done)
    );

    timer tmr(
        .clk(clk),
        .reset(reset_btn),
        .start(start_timer),
        .stop(stop_timer),
        .ms_time(ms_time)
    );

    seg7_driver display(
        .clk(clk),
        .reset(reset_btn),
        .value(ms_time),
        .show_error(show_error),
        .seg(seg),
        .an(an)
    );
endmodule
