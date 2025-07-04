module seg7_driver(
    input clk,
    input reset,
    input [13:0] value,
    input show_error,
    output reg [6:0] seg,
    output reg [3:0] an
);

    reg [3:0] digit_select;
    reg [19:0] refresh_counter;

    reg [6:0] seg_lut [0:11];
    initial begin
        seg_lut[0]  = 7'b1000000; // 0
        seg_lut[1]  = 7'b1111001; // 1
        seg_lut[2]  = 7'b0100100; // 2
        seg_lut[3]  = 7'b0110000; // 3
        seg_lut[4]  = 7'b0011001; // 4
        seg_lut[5]  = 7'b0010010; // 5
        seg_lut[6]  = 7'b0000010; // 6
        seg_lut[7]  = 7'b1111000; // 7
        seg_lut[8]  = 7'b0000000; // 8
        seg_lut[9]  = 7'b0010000; // 9
        seg_lut[10] = 7'b0000110; // E
        seg_lut[11] = 7'b0101111; // r
    end

    wire [3:0] digits [3:0];

    // Digit extraction with / and % — synthesis tools optimize constant division
    assign digits[3] = (value / 1000) % 10;
    assign digits[2] = (value / 100) % 10;
    assign digits[1] = (value / 10) % 10;
    assign digits[0] = value % 10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            refresh_counter <= 0;
            digit_select <= 0;
        end else begin
            refresh_counter <= refresh_counter + 1;
            if (refresh_counter[15:0] == 0)
                digit_select <= digit_select + 1;
        end
    end

    always @(*) begin
        reg [3:0] current_digit;

        seg = 7'b1111111; // default all off
        an  = 4'b1111;    // default all off

        if (show_error) begin
            case (digit_select)
                2'd0: begin seg = 7'b1111111; an = 4'b1110; end // blank
                2'd1: begin seg = seg_lut[11]; an = 4'b1101; end // r
                2'd2: begin seg = seg_lut[11]; an = 4'b1011; end // r
                2'd3: begin seg = seg_lut[10]; an = 4'b0111; end // E
                default: begin seg = 7'b1111111; an = 4'b1111; end
            endcase
            current_digit = 4'd0; // assign something to avoid latch
        end else begin
            current_digit = digits[digit_select];
            seg = seg_lut[current_digit];
            an = ~(4'b0001 << digit_select);
        end
    end

endmodule

