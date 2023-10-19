`include "../supported_modules/mux2to1_32bit.v"
`include "../zicsr/zicsr.v"

module interrupt_controller(
        input clk,
        input reset,
        input [31:0] pc_next;
        input interrupt_signal;
        output [31:0] pc_next_final;
        // output [31:0] pc_next_regfile;
        // output reg en_regfile;
        // input jalr_select_signal;
        // input [4:0] regfile_addr_1;
    );

    reg mux_sel;
    
    // Read from csr ??
    localparam ISR_PC = 20;
    
    // write pc to csr
    // assign pc_next_regfile = pc_next;

    //state machine states
    localparam  IDLE_STATE = 0, // normal operation 
                ISR_INIT_STATE = 1, // store pc move to ISR and set flag in csr
                RETURN_STATE = 2; // return state
                // RETURN_STATE = 3; // load pc and resume

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
                if (interrupt_signal == 1'b1)
                    next_state = ISR_INIT_STATE;
                else 
                    next_state = IDLE_STATE;
            end
            ISR_INIT_STATE:
                next_state = RETURN_STATE;
            RETURN_STATE: begin
                if (return_from_isr == 1'b1) 
                    next_state = IDLE;:
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
                mux_sel = 1'b1;
                // read isr from csr
                // write pc to csr
                // mux to isr
            end
            RETURN_STATE: begin
                mux_sel = 1'b0;
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
            // if (current_state == ISR_INIT_STATE)
            //     en_regfile = 1'b1;
            // else    
            //     en_regfile = 1'b0; 
            
        end
    end
    
endmodule