module axi4_slave(
    input wire clk,
    input wire reset,
    input wire [31:0] awaddr, // receive write address
    input wire awvalid, // write address valid
    output wire awready, // write address is ready
    input wire [31:0] wdata, // receive write data
    input wire [3:0] wstrb, // write strobes
    input wire wvalid, // write valid
    output wire wready,
    output wire [1:0] bresp,
    output wire bvalid,
    output wire [1:0] bready
);

reg [31:0] fifo [0:15];
reg [4:0] write_pointer;
reg [4:0] read_pointer;
reg [31:0] data;

always @(posedge clk) begin
    if (reset) begin
        write_pointer <= 5'b0;
        read_pointer <= 5'b0;
        data <= 32'b0;
    end else begin
        if (awvalid && awready && wvalid && wready) begin
            fifo[write_pointer] <= wdata;
            write_pointer <= write_pointer + 5'b1;
        end

        if (bvalid && bready) begin
            response <= 2'b00;
        end
    end
end

assign awready = 1'b1;
assign wready = 1'b1;
assign bresp = response;
assign bvalid = 1'b1;
assign bready = 1'b1;

// FIFO logic to read data from the slave

endmodule
