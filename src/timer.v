module timer(
    input clk, reset, start, stop,
    output reg [13:0] ms_time // 0-9999 ms
);
    reg [16:0] count_100us;
    reg counting;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count_100us <= 0;
            ms_time <= 0;
            counting <= 0;
        end else begin
            if (start)
                counting <= 1;
            if (stop)
                counting <= 0;

            if (counting) begin
                count_100us <= count_100us + 1;

                if (count_100us == 99999) begin
                    count_100us <= 0;
                    if (ms_time < 9999)
                        ms_time <= ms_time + 1;
                end
            end
        end
    end
endmodule
