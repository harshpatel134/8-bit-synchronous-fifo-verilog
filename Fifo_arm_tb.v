`timescale 1ns/1ps

module Fifo_arm_tb;

    reg clk;
    reg rst;
    reg write_en;
    reg read_en;
    reg [7:0] data_in;

    wire [7:0] data_out;
    wire full;
    wire empty;

    // Golden model array to check Data Integrity
    reg [7:0] expected_data [0:7];
    integer i = 0;

    // DUT
    Fifo_arm dut (
        .clk(clk),
        .rst(rst),
        .write_en(write_en),
        .read_en(read_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    // Clock generation (100 MHz)
    always #5 clk = ~clk;

    initial begin
        // Initial values
        clk      = 0;
        rst      = 1;
        write_en = 0;
        read_en  = 0;
        data_in  = 0;

        // -------------------------
        // 1. Reset Verification
        // -------------------------
        #10;
        rst = 0;
        $display("[TEST 1] Reset Released. Empty Flag: %b (Expected: 1)", empty);

        // -------------------------
        // 2. Write random data
        // -------------------------
        $display("\n[TEST 2] Writing Data...");
        for (i = 0; i < 8; i = i + 1) begin
            @(negedge clk);
            write_en = 1;
            read_en  = 0;
            data_in  = $urandom_range(8'h10, 8'hFF);
            expected_data[i] = data_in; // Store expected data
            $display("  Writing data_in[%0d] = %h", i, data_in);
        end

        // Stop writing
        @(negedge clk);
        write_en = 0;
        #1;
        $display("  Full Flag: %b (Expected: 1)", full);

        // -------------------------
        // 3. Read data & Verify Data Integrity
        // -------------------------
        $display("\n[TEST 3] Reading Data & Verifying Integrity...");
        for (i = 0; i < 8; i = i + 1) begin
            @(negedge clk);
            write_en = 0;
            read_en  = 1;
            
            @(posedge clk); // Wait for clk edge to allow DUT data_out register to update
            #1;
            if (data_out === expected_data[i]) begin
                $display("  Read[%0d] PASS: data_out = %h", i, data_out);
            end else begin
                $display("  Read[%0d] FAIL: data_out = %h (Expected: %h)", i, data_out, expected_data[i]);
            end
        end

        // Stop reading
        @(negedge clk);
        read_en = 0;
        #1;
        $display("  Empty Flag: %b (Expected: 1)", empty);

        // -------------------------
        // 4. Simultaneous Read/Write
        // -------------------------
        $display("\n[TEST 4] Testing Simultaneous Read/Write...");
        repeat (5) begin
            @(negedge clk);
            write_en = 1;
            read_en  = 1;
            data_in  = $urandom;
        end

        // Stop
        @(negedge clk);
        write_en = 0;
        read_en  = 0;

        // -------------------------
        // Finish
        // -------------------------
        #20;
        $display("\nSimulation Completed Successfully!");
        $finish;
    end

endmodule