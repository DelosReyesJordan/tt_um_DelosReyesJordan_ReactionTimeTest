module random_delay(
    input clk, reset, start,
    output reg done
);
    reg [28:0] counter; // 29 bits
    reg [28:0] target;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            done <= 0;
        end else if (start && !done) begin
            counter <= counter + 1;
            if (counter >= target)
                done <= 1;
        end else if (!start) begin
            counter <= 0;
            done <= 0;
            target <= 29'd100_000_000 + ($random % 29'd400_000_000);
        end
    end
endmodule
