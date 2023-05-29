module InstructionFetchUnit (
    input wire pInPC,
    input wire pAluOut,
    input wire pInMemData,
    input wire pIorD,
    input wire pClk,
    input wire pDataValid,
    input wire pIRWrite,
    input wire pReset,
    output wire pAddr,
    output wire pOutInstr,
    output wire pOutData,
    output wire pOutPC,
    output wire pDataLoaded
);
    reg [31:0] pc;
    reg [31:0] addr;
    reg [31:0] outInstr;
    reg [31:0] outData;
    reg [31:0] outPC;
    reg dataLoaded;

    always @(posedge pClk or posedge pReset) begin
        if (pReset) begin
            addr <= 0;
            outInstr <= 0;
            outData <= 0;
        end else begin
            if (pIorD) begin
                pc <= pAluOut;
                addr <= pc;
            end else begin
                pc <= pInPC;
                addr <= pc;
            end
        end
        outPC <= pc + 32'h4;
    end

    always @(posedge pClk) begin
        if (pDataValid && pIRWrite) begin
            dataLoaded <= 1;
            outInstr <= pInMemData;
            outData <= 0;
        end else if (pDataValid && !pIRWrite) begin
            dataLoaded <= 1;
            outInstr <= 0;
            outData <= pInMemData;
        end else begin
            dataLoaded <= 0;
            outInstr <= 0;
            outData <= 0;
        end
    end

    assign pAddr = addr;
    assign pOutInstr = outInstr;
    assign pOutData = outData;
    assign pOutPC = outPC;
    assign pDataLoaded = dataLoaded;

endmodule
