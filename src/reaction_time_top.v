module tt_um_DelosReyesJordan_ReactionTimeTest (
    input clk,
    input start_btn,
    input react_btn,
    input reset_btn,
    output led,
    output [6:0] seg,
    output [3:0] an
);
    wire delay_done, start_timer, stop_timer, show_error, finished;
    wire [13:0] ms_time;

    // Since FSM state is internal, to use state in random_delay start, we expose state as output
    wire [2:0] fsm_state;

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
        .finished(finished),
        .state_out(fsm_state)  // added state output for external usage
    );

    random_delay delay(
        .clk(clk),
        .reset(reset_btn),
        .start(fsm_state == 3'b001),  // WAIT state code (from reaction_fsm)
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
