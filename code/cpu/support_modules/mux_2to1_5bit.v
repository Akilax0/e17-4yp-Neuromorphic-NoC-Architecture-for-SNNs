`timescale 1ns/100ps

module mux_2to1_5bit (INPUT1, INPUT2, RESULT, SELECT);

    input [4:0] INPUT1, INPUT2;
    input SELECT;
    output reg [4:0] RESULT;

    always @ (*)
    begin
        if (SELECT == 1'b0)
            RESULT = INPUT1;
        else
            RESULT = INPUT2;
    end

endmodule