module decode(
    input clk,
    input reset,
    input [31:0] instruction,
    output reg [6:0] opcode_reg,
    output reg [4:0] rs1_reg,
    output reg [4:0] rs2_reg,
    output reg [4:0] rd_reg,
    output reg [2:0] funct3_reg,
    output reg [6:0] funct7_reg,
    output reg IorD_reg,
    output reg MemWrite_reg,
    output reg MtoR_reg,
    output reg IRWrite_reg,
    output reg [31:0] Imm_reg,
    output reg AluSrcA_reg,
    output reg [1:0] AluSrcB_reg,
    output reg RegWrite_reg,
    output reg [1:0] PCSrc_reg,
    output reg Branch_reg,
    output reg PCWrite_reg,
    output reg PCEn_reg,
    output reg [2:0] AluControl_reg,
    output reg [2:0] stage,
    output reg [2:0] next_stage
);
        always @(posedge clk) begin
            if (reset) begin
                opcode_reg <= 1'b0;
                rs1_reg <= 1'b0;
                rs2_reg <= 1'b0;
                rd_reg <= 1'b0;
                funct3_reg <= 1'b0;
                funct7_reg <= 1'b0;
                IorD_reg <= 1'b0;
                MemWrite_reg <= 1'b0;
                MtoR_reg <= 1'b0;
                IRWrite_reg <= 1'b0;
                Imm_reg <= 1'b0;
                AluSrcA_reg <= 1'b0;
                AluSrcB_reg <= 1'b0;
                RegWrite_reg <= 1'b0;
                PCSrc_reg <= 1'b0;
                Branch_reg <= 1'b0;
                PCWrite_reg <= 1'b0;
                PCEn_reg <= 1'b0;
                AluControl_reg <= 1'b0;
                stage <= 0;
                next_stage <= 0;
            end 
            else begin
                 case (stage)
    
                    0: begin //Fetching
                        #10
                        opcode_reg <= instruction[6:0];
                        rs1_reg <= instruction[19:15];
                        rs2_reg <= instruction[24:20];
                        rd_reg <= instruction[11:7];
                        funct3_reg <= instruction[14:12];
                        funct7_reg <= instruction[31:25];
                        IorD_reg <= 1'b0;
                        AluSrcA_reg <= 1'b0;
                        AluSrcB_reg <= 2'b01;
                        AluControl_reg <= 3'b000;
                        PCSrc_reg <= 1'b0;
                        IRWrite_reg <= 1'b1;
                        PCWrite_reg <= 1'b1;
                        case (opcode_reg)
                        7'b0110011: stage <= 2; //R-type
                        7'b0000011: stage <= 2; //I-type(load)
                        7'b0100011: stage <= 2; //S-type
                        endcase
                    end
    
    
                    2: begin //Execution/MemAdr
                        #10
                        case (opcode_reg)
                            // R-type instructions
                            7'b0110011: begin
                                if (funct7_reg == 7'b0000000) begin
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
                                end
                                else if (funct7_reg == 7'b0100000) begin
                                    case (funct3_reg)
                                        3'b000: AluControl_reg <= 3'b000;
                                        3'b101: AluControl_reg <= 3'b101;
                                    endcase
                                end
                                AluSrcA_reg <= 1'b1;
                                AluSrcB_reg <= 2'b00;
                                stage <= 5;
                            end
                            // I-type instructions(load)
                            7'b0000011: begin
                                AluSrcA_reg <= 1'b1;
                                AluSrcB_reg <= 2'b10;
                                Imm_reg <= {{20{instruction[31]}}, instruction[31:20]};
                                case (funct3_reg)
                                    3'b000: AluControl_reg <= 3'b000;
                                    3'b001: AluControl_reg <= 3'b001;
                                    3'b010: AluControl_reg <= 3'b010;
                                    3'b100: AluControl_reg <= 3'b100;
                                    3'b101: AluControl_reg <= 3'b101;
                                endcase
                                stage <= 3;
                            end
                            // S-type instructions
                            7'b0100011: begin
                                AluSrcA_reg <= 1'b1;
                                AluSrcB_reg <= 2'b10;
                                Imm_reg <= {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
                                case (funct3_reg)
                                    3'b000: AluControl_reg <= 3'b000;
                                    3'b001: AluControl_reg <= 3'b001;
                                    3'b010: AluControl_reg <= 3'b010;
                                endcase
                                stage <= 5;
                            end
                            // Invalid instruction
                                default: begin
                                stage <= 5;
                            end
                        endcase
                    end
    
    
                    3: begin //MemRead
                        #10
                        case (opcode_reg)
                            // I-type instructions(load)
                            7'b0000011: begin
                                IorD_reg <= 1'b1;
                                stage <= 5;
                            end
                        endcase
                    end
    
                    
                    5: begin //Writeback
                        #10
                        case (opcode_reg)
                            // R-type instructions
                            7'b0110011: begin
                                MtoR_reg <= 0;
                                RegWrite_reg <=1;
                            end
                            // I-type instructions(load)
                            7'b0000011: begin
                                MtoR_reg <= 1'b1;
                                RegWrite_reg <= 1'b1;
                            end
                            // S-type instructions
                            7'b0100011: begin
                                IorD_reg <= 1'b1;
                                MemWrite_reg <= 1'b1;
                            end
                        endcase
                       stage <= 0;
                    end
                endcase
            end
        end
endmodule
