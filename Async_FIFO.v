`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.12.2025 11:52:10
// Design Name: 
// Module Name: Async_FIFO
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


`timescale 1ns / 1ps

module Async_FIFO #(
    parameter WIDTH = 32,
    parameter DEPTH = 8,
    parameter ADDR_WIDTH = 3
)(
    // Write Domain
    input wr_clk, wr_reset_n,
    input wr_en,
    input [WIDTH-1:0] data_in,
    output full,

    // Read Domain
    input rd_clk, rd_reset_n,
    input rd_en,
    output [WIDTH-1:0] data_out,
    output empty
);

    reg [WIDTH-1:0] mem [0:DEPTH-1];
    reg [ADDR_WIDTH:0] wr_ptr, rd_ptr; // Binary pointers (extra bit for full/empty)
    wire [ADDR_WIDTH:0] wr_ptr_gray, rd_ptr_gray;
    reg [ADDR_WIDTH:0] wr_ptr_gray_sync1, wr_ptr_gray_sync2;
    reg [ADDR_WIDTH:0] rd_ptr_gray_sync1, rd_ptr_gray_sync2;

    // --- 1. Binary to Gray Conversion ---
    assign wr_ptr_gray = wr_ptr ^ (wr_ptr >> 1);
    assign rd_ptr_gray = rd_ptr ^ (rd_ptr >> 1);

    // --- 2. Write Domain Logic ---
    always @(posedge wr_clk or negedge wr_reset_n) begin
        if (!wr_reset_n) begin
            wr_ptr <= 0;
        end else if (wr_en && !full) begin
            mem[wr_ptr[ADDR_WIDTH-1:0]] <= data_in;
            wr_ptr <= wr_ptr + 1;
        end
    end

    // --- 3. Read Domain Logic ---
    always @(posedge rd_clk or negedge rd_reset_n) begin
        if (!rd_reset_n) begin
            rd_ptr <= 0;
        end else if (rd_en && !empty) begin
            rd_ptr <= rd_ptr + 1;
        end
    end
    assign data_out = mem[rd_ptr[ADDR_WIDTH-1:0]];

    // --- 4. Synchronization (2-Stage) ---
    // Synchronize Read Pointer to Write Clock
    always @(posedge wr_clk) begin
        rd_ptr_gray_sync1 <= rd_ptr_gray;
        rd_ptr_gray_sync2 <= rd_ptr_gray_sync1;
    end

    // Synchronize Write Pointer to Read Clock
    always @(posedge rd_clk) begin
        wr_ptr_gray_sync1 <= wr_ptr_gray;
        wr_ptr_gray_sync2 <= wr_ptr_gray_sync1;
    end

    // --- 5. Full and Empty Flags ---
    // Full condition: MSB and second MSB are different, rest same
    assign full = (wr_ptr_gray == {~rd_ptr_gray_sync2[ADDR_WIDTH:ADDR_WIDTH-1], rd_ptr_gray_sync2[ADDR_WIDTH-2:0]});
    // Empty condition: Pointers are identical
    assign empty = (rd_ptr_gray == wr_ptr_gray_sync2);

endmodule
