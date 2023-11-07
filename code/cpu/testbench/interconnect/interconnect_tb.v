`timescale 1ns / 1ps
`include "../../interconnect/interconnect.v"

module interconnect_tb();
    reg clk;
    reg reset;

    reg [1:0] a_n_addr_in;
    reg [31:0] a_data_in;
    wire [1:0] a_n_addr_out;
    wire [31:0] a_data_out;
    reg a_read_en;
    reg a_write_en;

    reg [1:0] b_n_addr_in;
    reg [31:0] b_data_in; 
    wire [1:0] b_n_addr_out;
    wire [31:0] b_data_out;
    reg b_read_en;
    reg b_write_en;

    interconnect my_in(
        clk,
        reset,
        a_n_addr_in,
        a_data_in, 
        a_n_addr_out,
        a_data_out,
        a_read_en,
        a_write_en,
        b_n_addr_in,
        b_data_in, 
        b_n_addr_out,
        b_data_out,
        b_read_en,
        b_write_en
    );

    /*
    
    For simulation assuming neuron division as follows
    - core 1 => 2'b00
    - core 2 => 2'b01, 2'b10 
    
    */

    // VCD dump file
    initial begin
        $dumpfile("in_tb.vcd");
        $dumpvars(0, interconnect_tb);

        // Initalize signals
        
        clk = 1'b0;
        reset = 1'b1;
        a_n_addr_in = 2'b00;
        a_data_in = 32'h0;
        a_read_en = 1'b0; 
        a_write_en = 1'b0;

        b_n_addr_in = 2'b00;
        b_data_in  = 32'h0;
        b_read_en = 1'b0;
        b_write_en = 1'b0;

        #10;
        
        reset = 1'b0;
        a_n_addr_in = 2'b01;
        a_data_in = 32'hA5A5A5A5;
        a_read_en = 1'b0; 
        a_write_en = 1'b1;

        b_n_addr_in = 2'b00;
        b_data_in  = 32'hABABABAB;
        b_read_en = 1'b0;
        b_write_en = 1'b1;


        #10;
        reset = 1'b0;
        a_n_addr_in = 2'b10;
        a_data_in = 32'hAAAAAAAA;
        a_read_en = 1'b0; 
        a_write_en = 1'b1;

        b_n_addr_in = 2'b00;
        b_data_in  = 32'hBBBBBBAB;
        b_read_en = 1'b0;
        b_write_en = 1'b1;

        #10;
        reset = 1'b0;
        a_n_addr_in = 2'b01;
        a_data_in = 32'hAAAAAAAA;
        a_read_en = 1'b1; 
        a_write_en = 1'b0;

        b_n_addr_in = 2'b00;
        b_data_in  = 32'hBBBBBBAB;
        b_read_en = 1'b1;
        b_write_en = 1'b0;


        #10;
        reset = 1'b0;
        a_n_addr_in = 2'b01;
        a_data_in = 32'hAAAAAAAA;
        a_read_en = 1'b1; 
        a_write_en = 1'b0;

        b_n_addr_in = 2'b00;
        b_data_in  = 32'hBBBBBBAB;
        b_read_en = 1'b1;
        b_write_en = 1'b0;

        #10;
        // Perform additional read and write operations as needed
        // End simulation
        $finish;
    end

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

endmodule


