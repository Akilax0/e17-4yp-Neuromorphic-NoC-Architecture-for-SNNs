module zicsr_reg(
    input clk,
    input reset,
    input wire csr_index,
    input wire read_en,
    output reg[31:0] csr_out,
    input wire write_en,
    input wire[31:0] csr_data
);


   //CSR addresses
   //machine trap handling//machine info
    localparam mscratch = 12'h340,  // scratch register for machine trap handlers
        
    // CSR register bits
    reg[31:0] mscratch; //dedicated for use by machine code

    
    //control logic for writing to CSRs
    always @(posedge clk,negedge reset) begin
        if(!reset) begin
            mscratch <= 0;
        end
        
        //MSCRATCH used as PC
        if(csr_index == MSCRATCH)begin
            mscratch <= csr_data;
        end
    end

    always@*begin
        case(csr_index)
            MSCRATCH: begin
                csr_out = mscratch;
            end
            default:
                csr_out = 0;
        endcase
    end
endmodule