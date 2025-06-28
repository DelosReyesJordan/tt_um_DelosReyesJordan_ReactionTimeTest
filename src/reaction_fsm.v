module reaction_fsm(
    input clk, reset, start_btn, react_btn,
    input delay_done, 
    input [13:0] elapsed_time, // max 9999
    output reg led,
    output reg start_timer, stop_timer, show_error, done
);

    // State encoding
    parameter IDLE  = 3'b000,
              WAIT  = 3'b001,
              READY = 3'b010,
              TIMING= 3'b011,
              DONE  = 3'b100,
              ERROR = 3'b101;

    reg [2:0] state, next;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next;
    end

    // Next state logic and outputs
    always @(*) begin
        next = state;
        led = 0;
        start_timer = 0;
        stop_timer = 0;
        show_error = 0;
        done = 0;

        case (state)
            IDLE: begin
                if (start_btn)
                    next = WAIT;
            end

            WAIT: begin
                if (react_btn)
                    next = ERROR;
                else if (delay_done)
                    next = READY;
            end

            READY: begin
                led = 1;
                start_timer = 1;
                next = TIMING;
            end

            TIMING: begin
                led = 1;
                if (react_btn) begin
                    stop_timer = 1;
                    next = DONE;
                end
            end

            DONE: begin
                done = 1;
                if (start_btn)
                    next = IDLE;
            end

            ERROR: begin
                show_error = 1;
                if (start_btn)
                    next = IDLE;
            end

            default: next = IDLE;
        endcase
    end

endmodule
