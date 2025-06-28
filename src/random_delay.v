module random_delay(
    input clk, reset, start,
    output reg done
);
    reg [28:0] counter;
    reg [28:0] target;

    // Simple LFSR for pseudo-random number generation
    reg [15:0] lfsr;
    wire feedback = lfsr[15] ^ lfsr[13] ^ lfsr[12] ^ lfsr[10];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            done <= 0;
            lfsr <= 16'hACE1; // seed
        end else begin
            
            lfsr <= {lfsr[14:0], feedback};

            if (!start) begin
                counter <= 0;
                done <= 0;
                // Create pseudo-random delay between ~1s and ~5s
                target <= 29'd25_000_000 + (lfsr * 29'd100_000);
            end else if (start && !done) begin
                counter <= counter + 1;
                if (counter >= target)
                    done <= 1;
            end
        end
    end
endmodule
