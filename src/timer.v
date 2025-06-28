module timer(
    input clk, reset, start, stop,
    output reg [13:0] ms_time
);
    reg [14:0] cycle_count;
    reg counting;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            cycle_count <= 0;
            ms_time <= 0;
            counting <= 0;
        end else begin
            if (start)
                counting <= 1;
            if (stop)
                counting <= 0;

            if (counting) begin
                cycle_count <= cycle_count + 1;
                if (cycle_count == 25000) begin
                    cycle_count <= 0;
                    ms_time <= ms_time + 1;
                end
            end
        end
    end
endmodule
