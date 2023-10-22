module axi4_master(
    input wire clk, 
    input wire reset,
    output wire [31:0] awaddr, //write address 
    output wire awvalid, // write address valid
    input wire awready, // write address ready
    output wire [31:0] wdata, // write data
    output wire [3:0] wstrb, // write strobes 
    output wire wvalid, // write valid
    input wire wready, // write ready to accept
    input wire [1:0] bresp, // write response
    input wire bvalid, // write response valid
    input wire bready // Response ready
);

reg [31:0] data_packet;
reg [31:0] write_address;
reg [1:0] response;

assign awaddr = write_address;
assign awvalid = 1'b1;
assign wdata = data_packet;
assign wstrb = 4'b1111;
assign wvalid = 1'b1;

always @(posedge clk) begin
    if (reset) begin
        write_address <= 32'b0;
        data_packet <= 32'b0;
        response <= 2'b00;
    end else begin
        if (awready && wready && bready) begin
            data_packet <= data_packet + 32'b1;
            write_address <= write_address + 32'b4;
            response <= 2'b00;
        end
    end
end

assign bresp = response;
assign bvalid = 1'b1;
assign bready = 1'b1;

endmodule
