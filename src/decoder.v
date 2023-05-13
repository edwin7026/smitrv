module decode_unit (
    input clk,
    input reset,
    input [31:0] instruction,
    output [6:0] opcode,
    output [4:0] rs1,
    output [4:0] rs2,
    output [4:0] rd,
    output [2:0] funct3,
    output [6:0] funct7,
    output IorD,
    output MemWrite,
    output MtoR,
    output IRWrite,
    output [1:0] ImmSel,
    output [31:0] Imm,
    output AluSrcA,
    output [1:0] AluSrcB,
    output RegWrite,
    output [1:0] PCSrc,
    output Branch,
    output PCWrite,
    output PCEn,
    output [2:0] AluControl
);

    reg [6:0] opcode_reg;
    reg [4:0] rs1_reg;
    reg [4:0] rs2_reg;
    reg [4:0] rd_reg;
    reg [2:0] funct3_reg;
    reg [6:0] funct7_reg;
    reg IorD_reg,
    reg MemWrite_reg,
    reg MtoR_reg,
    reg IRWrite_reg,
    reg [1:0] ImmSel_reg;
    reg [31:0] Imm_reg;
    reg AluSrcA_reg,
    reg [1:0] AluSrcB_reg,
    reg RegWrite_reg,
    reg [1:0] PCSrc_reg,
    reg Branch_reg,
    reg PCWrite_reg,
    reg PcEn_reg,
    reg [2:0] AluControl_reg;
    reg [2:0] stage;
    reg [2:0] next_stage;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            opcode_reg <= 0;
            rs1_reg <= 0;
            rs2_reg <= 0;
            rd_reg <= 0;
            funct3_reg <= 0;
            funct7_reg <= 0;
            IorD_reg <= 0;
            MemWrite_reg <= 0;
            MtoR_reg <= 0;
            IRWrite_reg <= 0;
            ImmSel_reg <= 0;
            Imm_reg <= 0;
            AluSrcA_reg <= 0;
            AluSrcB_reg <= 0;
            RegWrite_reg <= 0;
            PCSrc_reg <= 0;
            Branch_reg <= 0;
            PCWrite_reg <= 0;
            PCEn_reg <= 0;
            AluControl_reg <= 0;
            stage <= 0;
            next_stage <= 0;
        end 
        else begin
            case (stage)
                0: begin //Fetching
                    opcode_reg <= instruction[6:0];
                    rs1_reg <= instruction[19:15];
                    rs2_reg <= instruction[24:20];
                    rd_reg <= instruction[11:7];
                    funct3_reg <= instruction[14:12];
                    funct7_reg <= instruction[31:25];
                    IorD_reg <= 0;
                    AluSrcA_reg <= 0;
                    AluSrcB_reg <= 01;
                    AluControl_reg <= 3'b000;
                    PCSrc_reg <= 0;
                    IRWrite_reg <= 1;
                    PCWrite_reg <= 1;
                    next_stage <= 1;
                end
                1: begin //Decoding
                    AluSrcA_reg <= 0;
                    AluSrcB_reg <= 11;
                    AluControl_reg <= 3'b000;
                    next_stage <= 2;
                end
                2: begin //Execution
                    case (opcode_reg)
                        // R-type instructions
                        7'b0110011: begin
                            if funct7_reg == 7'b0000000: begin
                                case (funct3_reg)
                                    3'b000: AluControl_reg <= 3'b000;
                                    3'b001: AluControl_reg <= 3'b001;
                                    3'b010: AluControl_reg <= 3'b010;
                                    3'b011: AluControl_reg <= 3'b011;
                                    3'b100: AluControl_reg <= 3'b100;
                                    3'b101: AluControl_reg <= 3'b101;
                                    3'b110: AluControl_reg <= 3'b110;
                                    3'b111: AluControl_reg <= 3'b111;
                                endcase
                            else if funct7_reg == 7'b0100000: begin
                                case (funct3_reg)
                                    3'b000: AluControl_reg <= 3'b000;
                                    3'b101: AluControl_reg <= 3'b101;
                                endcase
                            end
                            AluSrcA <= 1'b1;
                            AluSrcB <= 2'b10;
                            next_stage <= 4;
                        end
                        // Invalid instruction
                            default: begin
                            next_stage <= 4;
                        end
                    endcase
                end
                4: begin //Writeback
                    MtoR_reg <= 0;
                    RegWrite_reg <=1;
                    opcode <= opcode_reg;
                    rs1 <= rs1_reg;
                    rs2 <= rs2_reg;
                    rd <= rd_reg;
                    funct3 <= funct3_reg;
                    funct7 <= funct7_reg;
                    IorD <= IorD_reg;
                    MemWrite <= MemWrite_reg;
                    MtoR <= MtoR_reg;
                    IRWrite <= IRWrite_reg;
                    ImmSel <= ImmSel_reg;
                    Imm <= Imm_reg;
                    AluSrcA <= AluSrcA_reg;
                    AluSrcB <= AluSrcB_reg;
                    RegWrite <= RegWrite_reg;
                    PCSrc <= PCSrc_reg;
                    Branch <= Branch_reg;
                    PCWrite <= PCWrite_reg;
                    PCEn <= PCEn_reg;
                    AluControl <= AluControl_reg;
                    stage <= next_stage;
                    next_stage <= 0;
                end
            endcase
        end
    end
endmodule
