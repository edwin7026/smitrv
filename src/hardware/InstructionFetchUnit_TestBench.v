module InstructionFetchUnit_TestBench;
    reg pInPC;
    reg pAluOut;
    reg pInMemData;
    reg pIorD;
    reg pClk;
    reg pDataValid;
    reg pIRWrite;
    reg pReset;
    
    wire pAddr;
    wire pOutInstr;
    wire pOutData;
    wire pOutPC;
    wire pDataLoaded;
    
    InstructionFetchUnit DUT (
        .pInPC(pInPC),
        .pAluOut(pAluOut),
        .pInMemData(pInMemData),
        .pIorD(pIorD),
        .pClk(pClk),
        .pDataValid(pDataValid),
        .pIRWrite(pIRWrite),
        .pReset(pReset),
        .pAddr(pAddr),
        .pOutInstr(pOutInstr),
        .pOutData(pOutData),
        .pOutPC(pOutPC),
        .pDataLoaded(pDataLoaded)
    );
    
    initial begin
        $dumpfile("simulation.vcd");
        $dumpvars(0, InstructionFetchUnit_TestBench);

        pClk = 0;
        pReset = 1;
        #10 pReset = 0; // Deassert reset after 10 time units
        
        // Test Case 1: Fetch from Instruction Memory
        pInPC = 32'h1000;
        pAluOut = 0;
        pInMemData = 32'h12345678;
        pIorD = 0;
        pDataValid = 1;
        pIRWrite = 1;
        #20;
        
        // Test Case 2: Fetch from Data Memory
        pInPC = 32'h2000;
        pAluOut = 0;
        pInMemData = 32'h87654321;
        pIorD = 1;
        pDataValid = 1;
        pIRWrite = 0;
        #20;
        
        // Test Case 3: Fetch from ALU output
        pInPC = 32'h3000;
        pAluOut = 32'h4000;
        pInMemData = 0;
        pIorD = 1;
        pDataValid = 1;
        pIRWrite = 1;
        #20;
        
        // Run the simulation for additional time
        #100;
        
        $finish;
    end
    
    always #5 pClk = ~pClk;
    
    reg [6:0] sim_time = 0;
    integer sim_duration = 500; // Set the desired simulation duration here
    
    always @(posedge pClk) begin
        if (pDataLoaded && pIRWrite) begin
            $display("Output Instruction: %h", pOutInstr);
        end else if (pDataLoaded && !pIRWrite) begin
            $display("Output Data: %h", pOutData);
        end
        
        if (sim_time == sim_duration) begin
            $display("Simulation finished at time %d", sim_time);
            $finish;
        end
        sim_time = sim_time + 1;
    end
endmodule
