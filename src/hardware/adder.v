// This is a simple example of a 4-bit adder

module adder (A,
            B,
            Sum
    );

    input [3:0] A;
    input [3:0] B;

    output [3:0] Sum;

    assign Sum = A + B;
        
endmodule