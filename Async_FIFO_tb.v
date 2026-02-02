`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.12.2025 11:53:39
// Design Name: 
// Module Name: Async_FIFO_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Async_FIFO_tb;
    reg wr_clk, rd_clk, wr_reset_n, rd_reset_n, wr_en, rd_en;
    reg [31:0] data_in;
    wire [31:0] data_out;
    wire full, empty;

  Async_FIFO #(
    .WIDTH(32),       // Data ki width
    .DEPTH(8),       // FIFO ki depth
    .ADDR_WIDTH(3)    // Depth ke hisaab se address bits (2^3 = 8)
) uut (
    .wr_clk(wr_clk),
    .wr_reset_n(wr_reset_n),
    .wr_en(wr_en),
    .data_in(data_in),
    .full(full),
    .rd_clk(rd_clk),
    .rd_reset_n(rd_reset_n),
    .rd_en(rd_en),
    .data_out(data_out),
    .empty(empty)
);

    // Write Clock (100MHz)
    initial begin wr_clk = 0; forever #5 wr_clk = ~wr_clk; end
    // Read Clock (50MHz)
    initial begin rd_clk = 0; forever #10 rd_clk = ~rd_clk; end

    initial begin
        // Reset
        wr_reset_n = 0; rd_reset_n = 0; wr_en = 0; rd_en = 0; data_in = 0;
        #30 wr_reset_n = 1; rd_reset_n = 1;

        // Write fast
        repeat(8) begin
            @(posedge wr_clk);
            if (!full) begin
                wr_en = 1; data_in = data_in + 1;
            end
        end
        @(posedge wr_clk) wr_en = 0;

        // Read slow
        repeat(8) begin
            @(posedge rd_clk);
            if (!empty) rd_en = 1;
        end
        @(posedge rd_clk) rd_en = 0;

        #200 $stop;
    end
endmodule
