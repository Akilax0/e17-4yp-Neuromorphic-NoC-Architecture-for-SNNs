`include "axi/axi4_master.v"
`include "axi/axi4_slave.v"

module axi4_tb();

  reg clk;
  reg reset;

  wire [31:0] awaddr;
  wire awvalid;
  wire awready;
  wire [31:0] wdata;
  wire [3:0] wstrb;
  wire wvalid;
  wire wready;
  wire [1:0] bresp;
  wire bvalid;
  wire [1:0] bready;

  wire [31:0] awaddr_slave;
  wire awvalid_slave;
  wire awready_slave;
  wire [31:0] wdata_slave;
  wire [3:0] wstrb_slave;
  wire wvalid_slave;
  wire wready_slave;
  wire [1:0] bresp_slave;
  wire bvalid_slave;
  wire [1:0] bready_slave;

  // Instantiate the AXI Master and Slave modules
  axi4_master master (
      .clk(clk),
      .reset(reset),
      .awaddr(awaddr),
      .awvalid(awvalid),
      .awready(awready),
      .wdata(wdata),
      .wstrb(wstrb),
      .wvalid(wvalid),
      .wready(wready),
      .bresp(bresp),
      .bvalid(bvalid),
      .bready(bready)
  );

  axi4_slave slave (
      .clk(clk),
      .reset(reset),
      .awaddr(awaddr_slave),
      .awvalid(awvalid_slave),
      .awready(awready_slave),
      .wdata(wdata_slave),
      .wstrb(wstrb_slave),
      .wvalid(wvalid_slave),
      .wready(wready_slave),
      .bresp(bresp_slave),
      .bvalid(bvalid_slave),
      .bready(bready_slave)
  );

  // Clock generation
  always begin
    #5 clk = ~clk;
  end

  initial begin
    clk = 0;
    reset = 1;
    awaddr = 32'h0;
    awvalid = 0;
    awaddr_slave = 32'h0;
    awvalid_slave = 0;

    // Release reset
    reset = 0;

    // Generate AXI write transactions
    repeat (16) begin
      #10 awvalid = 1;
      awaddr = awaddr + 4;
      wvalid = 1;
      wdata = awaddr + 100; // Sending some data
      wstrb = 4'b1111;
      #10 wvalid = 0;
      wstrb = 4'b0000;
      wait(bvalid); // Wait for response
    end

    // End simulation
    $finish;
  end

endmodule

module tb_axi4();

  // Testbench code goes here

endmodule
