module Fifo_arm (
    input  wire       clk,
    input  wire       rst,
    input  wire       write_en,
    input  wire       read_en,
    input  wire [7:0] data_in,
    output reg  [7:0] data_out,
    output wire       full,
    output wire       empty
);

    parameter DEPTH     = 8;
    parameter PTR_WIDTH = $clog2(DEPTH);

    // Memory array
    reg [7:0] mem [0:DEPTH-1];

    // Pointers and element counter
    reg [PTR_WIDTH-1:0] write_ptr;
    reg [PTR_WIDTH-1:0] read_ptr;
    reg [PTR_WIDTH:0]   count;

    // Status flags
    assign full  = (count == DEPTH);
    assign empty = (count == 0);

    // Synchronous Single-Block Logic
    always @(posedge clk) begin
        if (rst) begin
            write_ptr <= 0;
            read_ptr  <= 0;
            data_out  <= 0;
            count     <= 0;
        end else begin
            // Write Operation
            if (write_en && !full) begin
                mem[write_ptr] <= data_in;
                if (write_ptr == DEPTH - 1)
                    write_ptr <= 0;
                else
                    write_ptr <= write_ptr + 1'b1;
            end

            // Read Operation
            if (read_en && !empty) begin
                data_out <= mem[read_ptr];
                if (read_ptr == DEPTH - 1)
                    read_ptr <= 0;
                else
                    read_ptr <= read_ptr + 1'b1;
            end

            // Counter Update Logic
            case ({write_en && !full, read_en && !empty})
                2'b10: count <= count + 1'b1; // Write only
                2'b01: count <= count - 1'b1; // Read only
                2'b11: count <= count;        // Read and Write simultaneously
                default: count <= count;
            endcase
        end
    end

endmodule
