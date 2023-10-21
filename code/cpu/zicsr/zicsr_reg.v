module zicsr_reg(
    input clk,
    input reset,
        
    // for csr instruction
    input wire[11:0] csr_index,
    input wire[31:0] i_imm, //unsigned immediate for immediate type of CSR instruction (new value to be stored to CSR)
    input wire[31:0] i_rs1, //Source register 1 value (new value to be stored to CSR)
    input wire[2:0] csr_select,
    // output reg[31:0] o_csr_out, //CSR value to be loaded to basereg

    // for interrupt controller
    // input wire read_en,
    output reg[31:0] csr_data, // output data 
    // input wire write_en,
    input wire[31:0] csr_inp, // input data
    input wire i_ce; // enter isr instructions 
);

    // wire [2:0] i_funct3;
    // assign i_funct3 = csr_select;
    
   //CSR operation type (funt3)
    localparam CSRRW = 3'b001,
               CSRRS = 3'b010,
               CSRRC = 3'b011,
               CSRRWI = 3'b101,
               CSRRSI = 3'b110,
               CSRRCI = 3'b111;

   //CSR addresses
   //machine trap handling//machine info
    localparam MSCRATCH = 12'h340,  // scratch register for machine trap handlers
               MTVEC = 12'h305, // machine trap handler base address for ISR
        
    reg[31:0] csr_in; //value to be stored to CSR
    // reg[31:0] csr_data; //value at current CSR address

    // CSR register bits
    reg[31:0] mscratch; //dedicated for use by machine code
    reg[31:0] mtvec_base; //address of i_pc after returning from interrupt (via MRET)
    
    //control logic for writing to CSRs
    always @(posedge clk,negedge reset) begin
        if(!reset) begin
            mscratch <= 0;
            mtvec_base <= 0;
            int <= 0;
        end
        
        //MSCRATCH used as PC
        if(csr_index == MSCRATCH)begin
            mscratch <= csr_in;
        end

        //MTVEC used as ISR address
        if(csr_index == MTVEC)begin
            mtvec_base <= csr_in;
        end

    end

    always@*begin
        case(csr_index)
            MSCRATCH: begin
                csr_data = mscratch;
            end
            MTVEC: begin
                csr_data = mtvec_base;
            end
            default:
                csr_data = 0;
        endcase

        if(i_ce != 0)begin      
            case(csr_select)
                CSRRW: csr_in = i_rs1; //CSR read-write
                CSRRS: csr_in = csr_data | i_rs1; //CSR read-set
                CSRRC: csr_in = csr_data & (~i_rs1); //CSR read-clear
                CSRRWI: csr_in = i_imm; //csr read-write immediate
                CSRRSI: csr_in = csr_data | i_imm;  //csr read-set immediate
                CSRRCI: csr_in = csr_data & (~i_imm); //csr read-clear immediate
                default: csr_in = 0;
            endcase
        end
        if(i_ce == 1)begin      
            case(csr_select)
                CSRRWI: csr_in = csr_inp ; //csr read-write immediate
                default: csr_in = 0;
            endcase
        end
    end
endmodule