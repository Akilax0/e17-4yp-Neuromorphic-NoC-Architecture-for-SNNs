/*
File: interconnect.v
Description: Temporary module to connect two Cores 

*/

`include "../../interconnect/gp_fifo.v"

module interconnect(
    input wire clk,
    input wire reset,
    input wire [1:0] a_n_addr_in,
    input wire [31:0] a_data_in, 
    output wire [1:0] a_n_addr_out,
    output wire [31:0] a_data_out,
    input wire a_read_en,
    input wire a_write_en,
    input wire [1:0] b_n_addr_in,
    input wire [31:0] b_data_in, 
    output wire [1:0] b_n_addr_out,
    output wire [31:0] b_data_out,
    input wire b_read_en,
    input wire b_write_en
);

    /*
    module gp_fifo(
        input clk,
        input reset,
        input write_en,
        input read_en,
        input [63:0] data_in,
        output reg [63:0] data_out,
        output reg error,
        output reg full,
        output reg empty,
        output reg [4:0] ocup
    );


    */

    wire [4:0] atob_ocup,btoa_ocup;
    wire atob_full, atob_empty, atob_err, btoa_full, btoa_empty, btoa_err;
    
    wire [33:0] atob_data_in,atob_data_out,btoa_data_in,btoa_data_out;

    //  ==== IF WE DONT CARE ABOUT SIGNALS AND JUST WANT 
    // TO SEND DATA USE THE ASSIGNS HERE =============
    // assign b_n_addr_out = a_n_addr_in;
    // assign b_data_out = a_data_in;

    // assign a_n_addr_out = b_n_addr_in;
    // assign a_data_out = b_data_in;
    
    assign atob_data_in[33:32] = a_n_addr_in; 
    assign atob_data_in[31:0] = a_data_in; 
    assign btoa_data_in[33:32] = b_n_addr_in; 
    assign btoa_data_in[31:0] = b_data_in; 
    

    assign a_n_addr_out = btoa_data_out[33:32];
    assign a_data_out = btoa_data_out[31:0]; 
    assign b_n_addr_out = atob_data_out[33:32];
    assign b_data_out = atob_data_out[31:0]; 

    gp_fifo atob(
        clk,
        reset,
        a_write_en,
        b_read_en,
        atob_data_in,
        atob_data_out,
        atob_err,
        atob_full,
        atob_empty,
        atob_ocup
    );

    gp_fifo btoa(
        clk,
        reset,
        b_write_en,
        a_read_en,
        btoa_data_in,
        btoa_data_out,
        btoa_err,
        btoa_full,
        btoa_empty,
        btoa_ocup
    );
endmodule