module Controle (
    input clock,
    input reset,
    output reg [5:0]estado
);

// ESTADOS
parameter FETCH_1ST_CLOCK = 6'b000000;
parameter FETCH_2ND_CLOCK = 6'b000001;
parameter FETCH_3RD_CLOCK = 6'b000010;
parameter DECODE = 6'b000011;
parameter EXECUCAO = 6'b000100;
parameter ADD_SUB_AND_2ND_CLOCK = 6'b000101;
parameter XCHG_2ND_CLOCK = 6'b000111;
parameter JAL_2ND_CLOCK = 6'b001000;
// OPCODES
parameter JUMP_OPCODE = 6'b000010;
parameter JAL_OPCODE = 6'b000011;


initial begin
    estado = FETCH_1ST_CLOCK;
end

always @(posedge clock) begin
	case(estado)
        FETCH_1ST_CLOCK:
            PCWrite = 1'b1;
            IRWrite = 1'b1;
            MemADD = 2'b00;
            PCSource = 2'b01;
            ALUControl = 3'b001;
            ALUSrcB = 3'b011;
            ALUSrcA = 1'b0;
            estado = FETCH_2ND_CLOCK;
        FETCH_2ND_CLOCK:
            PCWrite = 1'b1;
            IRWrite = 1'b1;
            MemADD = 2'b00;
            PCSource = 2'b01;
            ALUControl = 3'b001;
            ALUSrcB = 3'b011;
            ALUSrcA = 1'b0;
            estado = FETCH_3RD_CLOCK;
        FETCH_3RD_CLOCK:
            PCWrite = 1'b1;
            IRWrite = 1'b1;
            MemADD = 2'b00;
            PCSource = 2'b01;
            ALUControl = 3'b001;
            ALUSrcB = 3'b011;
            ALUSrcA = 1'b0;
            estado = DECODE;
        DECODE:
            ALUControl = 3'b001;
            ALUSrcB = 3'b100;
            ALUSrcA = 1'b0;
            RegAWrite = 1'b1;
            RegBWrite = 1'b1;
            estado = EXECUCAO;
        OPERAR:
            // Instrução do formato R
            if (instrucao[31:26] == 5'b00000) begin
                parameter funct = instrucao[5:0]
                
                parameter ADD = 6'b100000;
                parameter SUB = 6'b100000;
                parameter AND = 6'b001000;
                parameter JR = 6'b001000;
                parameter MFHI = 6'b010000;
                parameter MFLO = 6'b010010;
                parameter SLT = 6'b101010;
                parameter BREAK = 6'b001101;
                parameter RTE = 6'b010011;
                parameter XCHG = 6'b000101;

                case (funct)
                    ADD:
                        ALUControl = 3'b001;
                        ALUSrcB = 3'b000;
                        ALUSrcA = 1'b1;
                        estado = ADD_SUB_AND_2ND_CLOCK;
                    SUB:
                        ALUControl = 3'b010;
                        ALUSrcB = 3'b000;
                        ALUSrcA = 1'b1;
                        estado = ADD_SUB_AND_2ND_CLOCK;
                    AND:
                        ALUControl = 3'b011;
                        ALUSrcB = 3'b000;
                        ALUSrcA = 1'b1;
                        estado = ADD_SUB_AND_2ND_CLOCK;
                    JR:
                        PCWrite=1'b1;
                        PCSource = 3'b001;
                        ALUSrcA = 1'b1;
                        ALUControl = 3'b000;
                        estado = FETCH_1ST_CLOCK;
                    SLT:
                        RegWrite = 1'b1;
                        RegDest = 3'b001;
                        RegData = 4'b0010;
                        ALUSrc B = 3'b000;
                        ALUSrc A = 1'b1;
                        ALUControl = 3'b111;
                        estado = FETCH_1ST_CLOCK;
                    BREAK:
                        PCWrite=1'b1;
                        PCSource = 3'b001;
                        ALUControl = 3'b010;
                        ALUSrcB = 3'b011;
                        ALUSrcA = 1'b1;
                        estado = FETCH_1ST_CLOCK;
                    RTE:
                        PCWrite=1'b1;
                        PCSource = 3'b010;
                        estado = FETCH_1ST_CLOCK;
                    XCHG:
                        RegWrite =1'b1;
                        XCHGRegWrite=1'b1;
                        RegDest = 3'b000;
                        RegData = 4'b1000;
                        estado = FETCH_1ST_CLOCK;
                    MFH:
                        RegWrite =1'b1;
                        RegDest = 3'b001;
                        RegData = 4'b0001;
                        MuxHiLo = 1'b0;
                        estado = FETCH_1ST_CLOCK;
                    MFLO:
                        RegWrite =1'b1;
                        RegDest = 3'b001;
                        RegData = 4'b0001;
                        MuxHiLo = 1'b1;
                        estado = FETCH_1ST_CLOCK;
                endcase
            end else if (instrucao[31:26] == JUMP_OPCODE) begin
                PCWrite=1'b1;
                PCSource=3'b000;
                estado = FETCH_1ST_CLOCK;               
            end else if (instrucao[31:26] == JAL_OPCODE) begin
                ALUControl = 3'b001;
                ALUSrcB = 3'b011;
                ALUSrcA = 1'b0;
                estado = JAL_2ND_CLOCK;
            end
        ADD_SUB_AND_2ND_CLOCK:
            if(ALUOverflow) begin
                estado = EXCECAO;
            end else begin
                RegWrite=1'b1;
                RegDest = 3'b001;
                RegData = 4'b0000;
                estado = FETCH_1ST_CLOCK;
            end
        XCHG_2ND_CLOCK:
            RegWrite=1'b1;
            RegDest = 3'b100;
            RegData = 4'b0111;
            estado = FETCH_1ST_CLOCK;
        JAL_2ND_CLOCK:
            PCWrite=1'b1;
            RegWrite=1'b1;
            RegDest = 3'b010;
            RegData = 4'b0000;
            PCSource = 3'b000;
            estado = FETCH;
	endcase
end
endmodule