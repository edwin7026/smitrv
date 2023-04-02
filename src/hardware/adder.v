// This is a simple example of a 4-bit adder

module adder (CLK,
            input1,
            input2,
            sum
    );

    input CLK;
    input [3:0] input1;
    input [3:0] input2;

    output reg [3:0] sum;
    
    // A clock activated updation to demonstrate framework features
    always @(posedge CLK) begin
        sum = input1 + input2;
    end
        
endmodule