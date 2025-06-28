module reaction_fsm(
    input clk, reset, start_btn, react_btn,
    input delay_done, 
    input [13:0] elapsed_time, // max 9999
    output reg led,
    output reg start_timer, stop_timer, show_error, finished,
    output reg [2:0] state_out // optional: for debug or external observation
);

    // State encoding with localparam
    localparam IDLE  = 3'b000,
               WAIT  = 3'b001,
               READY = 3'b010,
               TIMING= 3'b011,
               DONE  = 3'b100,
               ERROR = 3'b101;

    reg [2:0] state, next;

    // State register (sequential logic)
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next;

        state_out <= state; // optional: for debug
    end

    // Next state logic and outputs (combinational logic)
    always @(*) begin
        // Default outputs
        next = state;
        led = 0;
        start_timer = 0;
        stop_timer = 0;
        show_error = 0;
        finished = 0;

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
                finished = 1;
                if (start_btn)
                    next = IDLE;
            end

            ERROR: begin
                show_error = 1;
                if (start_btn)
                    next = IDLE;
            end

            default: begin
                next = IDLE;
            end
        endcase
    end

endmodule

