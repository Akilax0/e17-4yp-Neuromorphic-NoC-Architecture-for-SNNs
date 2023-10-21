`include "../supported_modules/mux2to1_32bit.v"
`include "../zicsr/zicsr_reg.v"

module interrupt_controller(
        input clk,
        input reset,
        input [31:0] pc_next,
        input interrupt_signal,
        output [31:0] pc_next_final;
    );

    reg mux_sel,i_ce,return_from_isr;
    reg [31:0] csr_out;
    reg [31:0] csr_in;
    reg [11:0] csr;
    
    // Read from csr ??
    // localparam ISR_PC = 20;
    localparam ISR_PC = csr_out;
    
    // CSR instructions needed to access 
    localparam CSRRWI = 3'b101;

    localparam MSCRATCH = 12'h340,  // scratch register for machine trap handlers
               MTVEC = 12'h305, // machine trap handler base address for ISR

    // write pc to csr
    // assign pc_next_regfile = pc_next;
    zicsr_reg pc_csr(CLK, RESET, csr, 0, 0, CSRRWI, csr_out, csr_in, i_ce);

    //state machine states
    localparam  IDLE_STATE = 0, // normal operation 
                ISR_INIT_STATE = 1, // store pc in csr
                ISR_LOAD_STATE = 2, // load isr 
                ISR_STATE = 3, // isr run
                RETURN_STATE = 4; // return state load pc 

    reg [1:0] current_state, next_state;
    
    mux2to1_32bit pcMux(pc_next,ISR_PC,pc_next_final,mux_sel);

    // set the reset signal
    // reg return_from_isr;
    // always @* begin
    //     if (jalr_select_signal == 1'b1 )begin
    //         if (regfile_addr_1 == 5'd30) return_from_isr = 1'b1;
    //         else return_from_isr = 1'b0;
    //     end
    //     else return_from_isr = 1'b0;
    // end

    // combinational logic to calc next stage begin
    always @*begin
        case (current_state)
            IDLE_STATE: begin
                if (interrupt_signal == 1'b1)begin
                    next_state = ISR_INIT_STATE;
                    i_ce = 1'b1;
                end
                else 
                    next_state = IDLE_STATE;
            end
            ISR_INIT_STATE: begin
                next_state = ISR_LOAD_STATE;
            end
            ISR_LOAD_STATE: begin
                next_state = ISR_STATE;
            end
            ISR_STATE: begin
                next_state = RETURN_STATE;
            end
            RETURN_STATE: begin
                if (return_from_isr == 1'b1)begin
                    next_state = IDLE_STATE;
                    i_ce = 1'b0;
                end
                else
                    next_state = RETURN_STATE;
            end
        endcase 
    end

    // changing control signals according to the current state

    always @* begin
        case (current_state)
            IDLE_STATE: begin
                mux_sel = 1'b0;
            end
            ISR_INIT_STATE: begin
                mux_sel = 1'b0;
                csr = MSCRATCH;
                csr_in = pc_next;
                // write pc to csr
            end
            ISR_LOAD_STATE: begin
                mux_sel = 1'b1;
                csr = MTVEC; 
                // load isr and go to it 
            end
            ISR_STATE: begin
                mux_sel = 1'b0;
                // go through isr
            end
            RETURN_STATE: begin
                mux_sel = 1'b1;
                csr = MSCRATCH; 
                // read pc from csr 
                // use this 
            end
        endcase
    end 
    

    //state change in the negative edge of the clock signal
    always @(negedge clk)begin
        if (reset == 1'b1)
            current_state = IDLE_STATE;
        else begin
            current_state = next_state;
        end
    end
    
endmodule