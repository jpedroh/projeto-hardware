module Controle (
    input clock,
    input reset,
    input wire [5:0] Opcode,
    output reg PCWrite,
    output reg IRWrite,
    output reg[1:0] MemADD,
    output reg[2:0] PCSource,
    output reg[2:0] ALUControl,
    output reg[2:0] ALUSrcB,
    output reg ALUSrcA,
    output reg RegAWrite,
    output reg RegBWrite,
    output reg RegWrite,
    output reg[2:0] RegDest,
    output reg[3:0] RegData,
    output reg XCHGRegWrite,
    output reg MFH,
    output reg MuxHiLo,
    output reg MuxHi,
    output reg MuxLo,
    output reg MULT_OP,
    output reg DIV_OP,
	output reg Reg_HI_Write,
	output reg Reg_Lo_Write,
    output reg [5:0]estado,
    output reg MemWriteRead,
    output reg RegALUOutWrite,
    input wire ALUOverflow,
    input wire[5:0] funct,
    input wire mult_fim,
    input wire div_fim,
    input wire EQ,
    input wire GT
);


// ESTADOS
parameter FETCH_1ST_CLOCK = 0;
parameter FETCH_2ND_CLOCK = 1;
parameter FETCH_3RD_CLOCK = 2;
parameter DECODE = 3;
parameter EXECUCAO = 4;
parameter ADD_SUB_AND_2ND_CLOCK = 5;
parameter XCHG_2ND_CLOCK = 6;
parameter JAL_2ND_CLOCK = 7;
parameter ADDI_ADDIU_2ND_CLOCK = 8;
parameter MULT_2ND_CLOCK = 9;
parameter DIV_2ND_CLOCK = 10;
parameter BEQ_2ND_CLOCK = 11;
parameter BNE_2ND_CLOCK = 12;
parameter BLE_2ND_CLOCK = 13;
parameter BGT_2ND_CLOCK = 14;
parameter WAIT = 6'b111111;
parameter EXCECAO = 6'b111111;
// OPCODES
parameter JUMP_OPCODE = 6'b000010;
parameter JAL_OPCODE = 6'b000011;
parameter ADDI_OPCODE =6'b001000;
parameter ADDIU_OPCODE = 6'b001001;
parameter BEQ_OPCODE = 6'b000100;
parameter BNE_OPCODE = 6'b000101;
parameter BLE_OPCODE = 6'b000110;
parameter BGT_OPCODE = 6'b000111;

// FUNCT                
parameter ADD = 6'b100000;
parameter SUB = 6'b100010;
parameter AND = 6'b100100;
parameter JR = 6'b001000;
parameter MFHI = 6'b010000;
parameter MFLO = 6'b010010;
parameter SLT = 6'b101010;
parameter BREAK = 6'b001101;
parameter RTE = 6'b010011;
parameter XCHG = 6'b000101;
parameter MULT = 6'b011000;
parameter DIV = 6'b011010;

initial begin
    estado = FETCH_1ST_CLOCK;
end

always @(posedge clock) begin
	case(estado)
        FETCH_1ST_CLOCK: begin
            PCSource = 3'b001;
            PCWrite = 1'b1;
            MemADD = 2'b00;
            ALUControl = 3'b001;
            ALUSrcB = 3'b011;
            ALUSrcA = 1'b0;
            // Default
            IRWrite = 1'b0;
            RegAWrite = 1'b0;
            RegBWrite = 1'b0;
            RegWrite = 1'b0;
            RegDest = 3'b000;
            RegData = 4'b0000;
            XCHGRegWrite = 1'b0;
            MFH = 1'b0;
            MuxHiLo = 1'b0;
            MuxHi = 1'b0;
            MuxLo = 1'b0;
            MULT_OP = 1'b0;
            DIV_OP = 1'b0;
            Reg_HI_Write = 1'b0;
            Reg_Lo_Write = 1'b0;
            MemWriteRead = 1'b0;
            RegALUOutWrite = 1'b0;

            estado = FETCH_2ND_CLOCK;
            end
        FETCH_2ND_CLOCK: begin
            // Default
            PCWrite = 1'b0;
            IRWrite = 1'b0;
            MemADD = 2'b00;
            PCSource = 3'b000;
            ALUControl = 3'b000;
            ALUSrcB = 3'b000;
            ALUSrcA = 1'b0;
            RegAWrite = 1'b0;
            RegBWrite = 1'b0;
            RegWrite = 1'b0;
            RegDest = 3'b000;
            RegData = 4'b0000;
            XCHGRegWrite = 1'b0;
            MFH = 1'b0;
            MuxHiLo = 1'b0;
            MuxHi = 1'b0;
            MuxLo = 1'b0;
            MULT_OP = 1'b0;
            DIV_OP = 1'b0;
            Reg_HI_Write = 1'b0;
            Reg_Lo_Write = 1'b0;
            MemWriteRead = 1'b0;
            RegALUOutWrite = 1'b0;

            estado = FETCH_3RD_CLOCK;
            end
        FETCH_3RD_CLOCK: begin
            IRWrite = 1'b1;
            // Default
            PCWrite = 1'b0;
            MemADD = 2'b00;
            PCSource = 3'b000;
            ALUControl = 3'b000;
            ALUSrcB = 3'b000;
            ALUSrcA = 1'b0;
            RegAWrite = 1'b0;
            RegBWrite = 1'b0;
            RegWrite = 1'b0;
            RegDest = 3'b000;
            RegData = 4'b0000;
            XCHGRegWrite = 1'b0;
            MFH = 1'b0;
            MuxHiLo = 1'b0;
            MuxHi = 1'b0;
            MuxLo = 1'b0;
            MULT_OP = 1'b0;
            DIV_OP = 1'b0;
            Reg_HI_Write = 1'b0;
            Reg_Lo_Write = 1'b0;
            MemWriteRead = 1'b0;
            RegALUOutWrite = 1'b0;

            estado = DECODE;
        end
        DECODE: begin
            ALUControl = 3'b001;
            ALUSrcB = 3'b101;
            ALUSrcA = 1'b0;
            RegAWrite = 1'b1;
            RegBWrite = 1'b1;
            RegALUOutWrite = 1'b1;
            // Default
            PCWrite = 1'b0;
            IRWrite = 1'b0;
            MemADD = 2'b00;
            PCSource = 3'b000;
            RegWrite = 1'b0;
            RegDest = 3'b000;
            RegData = 4'b0000;
            XCHGRegWrite = 1'b0;
            MFH = 1'b0;
            MuxHiLo = 1'b0;
            MuxHi = 1'b0;
            MuxLo = 1'b0;
            MULT_OP = 1'b0;
            DIV_OP = 1'b0;
            Reg_HI_Write = 1'b0;
            Reg_Lo_Write = 1'b0;
            MemWriteRead = 1'b0;
            
            estado = EXECUCAO;
            end
        EXECUCAO: begin
            // Instrução do formato R
            if (Opcode == 6'b000000) begin
                case (funct)
                    ADD: begin
                        ALUControl = 3'b001;
                        ALUSrcB = 3'b000;
                        ALUSrcA = 1'b1;
                        RegALUOutWrite=1'b1;
                        //Inalteradas
                        PCWrite=1'b0;
                        IRWrite=1'b0;
                        MemADD=2'b00;
                        PCSource=3'b000;
                        RegAWrite=1'b0;
                        RegBWrite=1'b0;
                        RegWrite=1'b0;
                        RegDest=3'b000;
                        RegData=4'b0000;
                        XCHGRegWrite=1'b0;
                        MFH=1'b0;
                        MuxHiLo=1'b0;
                        MuxHi=1'b0;
                        MuxLo=1'b0;
                        MULT_OP=1'b0;
                        DIV_OP=1'b0;
                        Reg_HI_Write=1'b0;
                        Reg_Lo_Write=1'b0;
                        estado=1'b0;
                        MemWriteRead=1'b0;
                        estado = ADD_SUB_AND_2ND_CLOCK;
						end
                    SUB: begin
                        ALUControl = 3'b010;
                        ALUSrcB = 3'b000;
                        ALUSrcA = 1'b1;
                        RegALUOutWrite=1'b1;
                        //Inalteradas
                        PCWrite=1'b0;
                        IRWrite=1'b0;
                        MemADD=2'b00;
                        PCSource=3'b000;
                        RegAWrite=1'b0;
                        RegBWrite=1'b0;
                        RegWrite=1'b0;
                        RegDest=3'b000;
                        RegData=4'b0000;
                        XCHGRegWrite=1'b0;
                        MFH=1'b0;
                        MuxHiLo=1'b0;
                        MuxHi=1'b0;
                        MuxLo=1'b0;
                        MULT_OP=1'b0;
                        DIV_OP=1'b0;
                        Reg_HI_Write=1'b0;
                        Reg_Lo_Write=1'b0;
                        estado=1'b0;
                        MemWriteRead=1'b0;
                        estado = ADD_SUB_AND_2ND_CLOCK;
                        end
                    AND: begin
                        ALUControl = 3'b011;
                        ALUSrcB = 3'b000;
                        ALUSrcA = 1'b1;
                        RegALUOutWrite=1'b1;
                        //Inalteradas
                        PCWrite=1'b0;
                        IRWrite=1'b0;
                        MemADD=2'b00;
                        PCSource=3'b000;
                        RegAWrite=1'b0;
                        RegBWrite=1'b0;
                        RegWrite=1'b0;
                        RegDest=3'b000;
                        RegData=4'b0000;
                        XCHGRegWrite=1'b0;
                        MFH=1'b0;
                        MuxHiLo=1'b0;
                        MuxHi=1'b0;
                        MuxLo=1'b0;
                        MULT_OP=1'b0;
                        DIV_OP=1'b0;
                        Reg_HI_Write=1'b0;
                        Reg_Lo_Write=1'b0;
                        estado=1'b0;
                        MemWriteRead=1'b0;
                        estado = ADD_SUB_AND_2ND_CLOCK;
                        end
                    JR: begin
                        PCWrite = 1'b1;
                        PCSource = 3'b111;
                        // Default
                        ALUControl = 3'b000;
                        ALUSrcB = 3'b000;
                        ALUSrcA = 1'b0;
                        IRWrite = 1'b0;
                        MemADD = 2'b00;
                        RegAWrite = 1'b0;
                        RegBWrite = 1'b0;
                        RegWrite = 1'b0;
                        RegDest = 3'b000;
                        RegData = 4'b0000;
                        XCHGRegWrite = 1'b0;
                        MFH = 1'b0;
                        MuxHiLo = 1'b0;
                        MuxHi = 1'b0;
                        MuxLo = 1'b0;
                        MULT_OP = 1'b0;
                        DIV_OP = 1'b0;
                        Reg_HI_Write = 1'b0;
                        Reg_Lo_Write = 1'b0;
                        MemWriteRead = 1'b0;
                        RegALUOutWrite = 1'b0;
                        estado = WAIT;
                        end
                    SLT: begin
                        RegWrite = 1'b1;
                        RegDest = 3'b001;
                        RegData = 4'b0010;
                        ALUSrcB = 3'b000;
                        ALUSrcA = 1'b1;
                        ALUControl = 3'b111;
                        estado = WAIT;
                        end
                    BREAK: begin
                        PCWrite=1'b1;
                        PCSource = 3'b001;
                        ALUControl = 3'b010;
                        ALUSrcB = 3'b011;
                        ALUSrcA = 1'b1;
                        estado = WAIT;
                        end
                    RTE: begin
                        PCWrite=1'b1;
                        PCSource = 3'b010;
                        estado = WAIT;
                        end
                    XCHG: begin
                        RegWrite =1'b1;
                        XCHGRegWrite=1'b1;
                        RegDest = 3'b000;
                        RegData = 4'b1000;
                        estado = WAIT;
                        end
                    MFH: begin
                        RegWrite =1'b1;
                        RegDest = 3'b001;
                        RegData = 4'b0001;
                        MuxHiLo = 1'b0;
                        estado = WAIT;
                        end
                    MFLO: begin
                        RegWrite =1'b1;
                        RegDest = 3'b001;
                        RegData = 4'b0001;
                        MuxHiLo = 1'b1;
                        estado = WAIT;
                        end
					MULT: begin
						//inalterados
						RegWrite = 1'b0;
						RegDest = 3'b000;
						RegData = 4'b0000;
						PCWrite = 1'b0;
						IRWrite = 1'b0;
						MemADD = 2'b00;
						PCSource = 3'b000;
						ALUControl = 3'b000;
						ALUSrcB = 3'b000;
						ALUSrcA = 1'b0;
						RegAWrite = 1'b0;
						RegBWrite = 1'b0;
						XCHGRegWrite = 1'b0;
						MFH = 1'b0;
						MuxHiLo = 1'b0;
						MuxHi = 1'b0;
						MuxLo = 1'b0;
						DIV_OP = 1'b0;
						Reg_HI_Write = 1'b0;
						Reg_Lo_Write = 1'b0;
						MemWriteRead = 1'b0;
						RegALUOutWrite = 1'b0;
						//alterados
						MULT_OP = 1;
						estado = MULT_2ND_CLOCK;
					end
					DIV: begin
						//inalterados
						RegWrite = 1'b0;
						RegDest = 3'b000;
						RegData = 4'b0000;
						PCWrite = 1'b0;
						IRWrite = 1'b0;
						MemADD = 2'b00;
						PCSource = 3'b000;
						ALUControl = 3'b000;
						ALUSrcB = 3'b000;
						ALUSrcA = 1'b0;
						RegAWrite = 1'b0;
						RegBWrite = 1'b0;
						XCHGRegWrite = 1'b0;
						MFH = 1'b0;
						MuxHiLo = 1'b0;
						MuxHi = 1'b0;
						MuxLo = 1'b0;
						MULT_OP = 1'b0;
						Reg_HI_Write = 1'b0;
						Reg_Lo_Write = 1'b0;
						MemWriteRead = 1'b0;
						RegALUOutWrite = 1'b0;
						//alterados
						DIV_OP = 1;
						estado = DIV_2ND_CLOCK;
					end	
                endcase
            end else if (Opcode == JUMP_OPCODE) begin
                PCWrite=1'b1;
                PCSource=3'b101;
                // Default
                IRWrite = 1'b0;
                MemADD = 2'b00;
                ALUControl = 3'b000;
                ALUSrcB = 3'b000;
                ALUSrcA = 1'b0;
                RegAWrite = 1'b0;
                RegBWrite = 1'b0;
                RegWrite = 1'b0;
                RegDest = 3'b000;
                RegData = 4'b0000;
                XCHGRegWrite = 1'b0;
                MFH = 1'b0;
                MuxHiLo = 1'b0;
                MuxHi = 1'b0;
                MuxLo = 1'b0;
                MULT_OP = 1'b0;
                DIV_OP = 1'b0;
                Reg_HI_Write = 1'b0;
                Reg_Lo_Write = 1'b0;
                MemWriteRead = 1'b0;
                RegALUOutWrite = 1'b0;

                estado = WAIT;               
            end else if (Opcode == JAL_OPCODE) begin
                ALUControl = 3'b000;
                ALUSrcA = 1'b0;
                RegALUOutWrite = 1'b1;
                PCWrite=1'b1;
                PCSource=3'b101;
                // Default
                IRWrite = 1'b0;
                MemADD = 2'b00;
                ALUControl = 3'b000;
                ALUSrcB = 3'b000;
                ALUSrcA = 1'b0;
                RegAWrite = 1'b0;
                RegBWrite = 1'b0;
                RegWrite = 1'b0;
                RegDest = 3'b000;
                RegData = 4'b0000;
                XCHGRegWrite = 1'b0;
                MFH = 1'b0;
                MuxHiLo = 1'b0;
                MuxHi = 1'b0;
                MuxLo = 1'b0;
                MULT_OP = 1'b0;
                DIV_OP = 1'b0;
                Reg_HI_Write = 1'b0;
                Reg_Lo_Write = 1'b0;
                MemWriteRead = 1'b0;
                RegALUOutWrite = 1'b0;

                estado = JAL_2ND_CLOCK;
            end else if (Opcode == ADDI_OPCODE || Opcode == ADDIU_OPCODE) begin
                ALUControl = 3'b001;
                ALUSrcB = 3'b010;
                ALUSrcA = 1'b1;
                RegALUOutWrite = 1'b1;
                // Default
                RegWrite = 1'b0;
                RegDest = 3'b000;
                RegData = 4'b0000;
                PCWrite = 1'b0;
                IRWrite = 1'b0;
                MemADD = 2'b00;
                PCSource = 3'b000;
                RegAWrite = 1'b0;
                RegBWrite = 1'b0;
                RegDest = 3'b000;
                RegData = 4'b0000;
                XCHGRegWrite = 1'b0;
                MFH = 1'b0;
                MuxHiLo = 1'b0;
                MuxHi = 1'b0;
                MuxLo = 1'b0;
                MULT_OP = 1'b0;
                DIV_OP = 1'b0;
                Reg_HI_Write = 1'b0;
                Reg_Lo_Write = 1'b0;
                MemWriteRead = 1'b0;
                estado = ADDI_ADDIU_2ND_CLOCK;
            end else if (Opcode == BEQ_OPCODE) begin
                PCSource = 3'b100;
                ALUControl = 3'b111;
				ALUSrcA = 1'b1;
				ALUSrcB = 3'b000;
                // Default
                PCWrite = 1'b0;
                IRWrite = 1'b0;
                MemADD = 2'b00;
                RegAWrite = 1'b0;
                RegBWrite = 1'b0;
                RegWrite = 1'b0;
                RegDest = 3'b000;
                RegData = 4'b0000;
                XCHGRegWrite = 1'b0;
                MFH = 1'b0;
                MuxHiLo = 1'b0;
                MuxHi = 1'b0;
                MuxLo = 1'b0;
                MULT_OP = 1'b0;
                DIV_OP = 1'b0;
                Reg_HI_Write = 1'b0;
                Reg_Lo_Write = 1'b0;
                MemWriteRead = 1'b0;
                RegALUOutWrite = 1'b0;
                estado = BEQ_2ND_CLOCK;
            end else if (Opcode == BNE_OPCODE) begin
                PCSource = 3'b100;
                ALUControl = 3'b111;
				ALUSrcA = 1'b1;
				ALUSrcB = 3'b000;
                // Default
                PCWrite = 1'b0;
                IRWrite = 1'b0;
                MemADD = 2'b00;
                RegAWrite = 1'b0;
                RegBWrite = 1'b0;
                RegWrite = 1'b0;
                RegDest = 3'b000;
                RegData = 4'b0000;
                XCHGRegWrite = 1'b0;
                MFH = 1'b0;
                MuxHiLo = 1'b0;
                MuxHi = 1'b0;
                MuxLo = 1'b0;
                MULT_OP = 1'b0;
                DIV_OP = 1'b0;
                Reg_HI_Write = 1'b0;
                Reg_Lo_Write = 1'b0;
                MemWriteRead = 1'b0;
                RegALUOutWrite = 1'b0;
                estado = BNE_2ND_CLOCK;
            end else if (Opcode == BLE_OPCODE) begin
                PCSource = 3'b100;
                ALUControl = 3'b111;
				ALUSrcA = 1'b1;
				ALUSrcB = 3'b000;
                // Default
                PCWrite = 1'b0;
                IRWrite = 1'b0;
                MemADD = 2'b00;
                RegAWrite = 1'b0;
                RegBWrite = 1'b0;
                RegWrite = 1'b0;
                RegDest = 3'b000;
                RegData = 4'b0000;
                XCHGRegWrite = 1'b0;
                MFH = 1'b0;
                MuxHiLo = 1'b0;
                MuxHi = 1'b0;
                MuxLo = 1'b0;
                MULT_OP = 1'b0;
                DIV_OP = 1'b0;
                Reg_HI_Write = 1'b0;
                Reg_Lo_Write = 1'b0;
                MemWriteRead = 1'b0;
                RegALUOutWrite = 1'b0;
                estado = BLE_2ND_CLOCK;
            end else if (Opcode == BGT_OPCODE) begin
                PCSource = 3'b100;
                ALUControl = 3'b111;
				ALUSrcA = 1'b1;
				ALUSrcB = 3'b000;
                // Default
                PCWrite = 1'b0;
                IRWrite = 1'b0;
                MemADD = 2'b00;
                RegAWrite = 1'b0;
                RegBWrite = 1'b0;
                RegWrite = 1'b0;
                RegDest = 3'b000;
                RegData = 4'b0000;
                XCHGRegWrite = 1'b0;
                MFH = 1'b0;
                MuxHiLo = 1'b0;
                MuxHi = 1'b0;
                MuxLo = 1'b0;
                MULT_OP = 1'b0;
                DIV_OP = 1'b0;
                Reg_HI_Write = 1'b0;
                Reg_Lo_Write = 1'b0;
                MemWriteRead = 1'b0;
                RegALUOutWrite = 1'b0;
                estado = BGT_2ND_CLOCK;
            end
        end
        ADD_SUB_AND_2ND_CLOCK: begin
            if(ALUOverflow) begin
                estado = EXCECAO;
            end else begin
                RegWrite=1'b1;
                RegDest = 3'b001;
                RegData = 4'b1001;
                // Inalteradas
                PCWrite=1'b0;
                IRWrite=1'b0;
                MemADD=2'b00;
                PCSource=3'b000;
                ALUControl=3'b000;
                ALUSrcB=3'b000;
                ALUSrcA=1'b0;
                RegAWrite=1'b0;
                RegBWrite=1'b0;
                XCHGRegWrite=1'b0;
                MFH=1'b0;
                MuxHiLo=1'b0;
                MuxHi=1'b0;
                MuxLo=1'b0;
                MULT_OP=1'b0;
                DIV_OP=1'b0;
                Reg_HI_Write=1'b0;
                Reg_Lo_Write=1'b0;
                MemWriteRead=1'b0;
                RegALUOutWrite=1'b0;
                estado = WAIT;
            end
			end
        XCHG_2ND_CLOCK: begin
            RegWrite=1'b1;
            RegDest = 3'b100;
            RegData = 4'b0111;
            estado = WAIT;
            end
        JAL_2ND_CLOCK: begin
            RegDest = 3'b010;
            RegData = 4'b0000;
            RegWrite = 1'b1;
            // Default
            PCWrite = 1'b0;
            IRWrite = 1'b0;
            MemADD = 2'b00;
            PCSource = 3'b000;
            ALUControl = 3'b000;
            ALUSrcB = 3'b000;
            ALUSrcA = 1'b0;
            RegAWrite = 1'b0;
            RegBWrite = 1'b0;
            XCHGRegWrite = 1'b0;
            MFH = 1'b0;
            MuxHiLo = 1'b0;
            MuxHi = 1'b0;
            MuxLo = 1'b0;
            MULT_OP = 1'b0;
            DIV_OP = 1'b0;
            Reg_HI_Write = 1'b0;
            Reg_Lo_Write = 1'b0;
            MemWriteRead = 1'b0;
            RegALUOutWrite = 1'b0;
            estado = WAIT;
            end
        ADDI_ADDIU_2ND_CLOCK: begin
            RegWrite = 1'b1;
            RegDest = 3'b000;
            RegData = 4'b0000;
            // Default
            PCWrite = 1'b0;
            IRWrite = 1'b0;
            MemADD = 2'b00;
            PCSource = 3'b000;
            ALUControl = 3'b000;
            ALUSrcB = 3'b000;
            ALUSrcA = 1'b0;
            RegAWrite = 1'b0;
            RegBWrite = 1'b0;
            XCHGRegWrite = 1'b0;
            MFH = 1'b0;
            MuxHiLo = 1'b0;
            MuxHi = 1'b0;
            MuxLo = 1'b0;
            MULT_OP = 1'b0;
            DIV_OP = 1'b0;
            Reg_HI_Write = 1'b0;
            Reg_Lo_Write = 1'b0;
            MemWriteRead = 1'b0;
            RegALUOutWrite = 1'b0;
            estado = WAIT;
        end
        MULT_2ND_CLOCK:
			if (mult_fim == 0) begin
				estado = MULT_2ND_CLOCK;
			end
			else begin
				MULT_OP = 0;
				Reg_HI_Write= 1'b1;
				Reg_Lo_Write= 1'b1;
				MuxHi = 0;
				MuxLo = 0;
				estado = WAIT;
			end
		DIV_2ND_CLOCK: begin
			if (div_fim == 0) begin
				estado = DIV_2ND_CLOCK;
			end
			else begin
				DIV_OP = 0;
				Reg_HI_Write = 1'b1;
				Reg_Lo_Write = 1'b1;
				MuxHi = 1;
				MuxLo = 1;
				estado = WAIT;
			end
        end
        BEQ_2ND_CLOCK: begin
            // Alteradas
			PCSource = 3'b100;
			ALUSrcA = 2'b0;
			ALUSrcB = 3'b000;
            ALUControl = 3'b111;
		    if(EQ == 1) begin
				PCWrite = 1'b1;
			end
            // Default
            IRWrite = 1'b0;
            MemADD = 2'b00;
            RegAWrite = 1'b0;
            RegBWrite = 1'b0;
            RegWrite = 1'b0;
            RegDest = 3'b000;
            RegData = 4'b0000;
            XCHGRegWrite = 1'b0;
            MFH = 1'b0;
            MuxHiLo = 1'b0;
            MuxHi = 1'b0;
            MuxLo = 1'b0;
            MULT_OP = 1'b0;
            DIV_OP = 1'b0;
            Reg_HI_Write = 1'b0;
            Reg_Lo_Write = 1'b0;
            MemWriteRead = 1'b0;
            RegALUOutWrite = 1'b0;
            estado = WAIT;
        end
        BNE_2ND_CLOCK: begin
            // Alteradas
			PCSource = 3'b100;
			ALUSrcA = 2'b0;
			ALUSrcB = 3'b000;
            ALUControl = 3'b111;
		    if(EQ == 0) begin
				PCWrite = 1'b1;
			end
            // Default
            IRWrite = 1'b0;
            MemADD = 2'b00;
            RegAWrite = 1'b0;
            RegBWrite = 1'b0;
            RegWrite = 1'b0;
            RegDest = 3'b000;
            RegData = 4'b0000;
            XCHGRegWrite = 1'b0;
            MFH = 1'b0;
            MuxHiLo = 1'b0;
            MuxHi = 1'b0;
            MuxLo = 1'b0;
            MULT_OP = 1'b0;
            DIV_OP = 1'b0;
            Reg_HI_Write = 1'b0;
            Reg_Lo_Write = 1'b0;
            MemWriteRead = 1'b0;
            RegALUOutWrite = 1'b0;
            estado = WAIT;
        end
        BLE_2ND_CLOCK: begin
            // Alteradas
			PCSource = 3'b100;
			ALUSrcA = 2'b0;
			ALUSrcB = 3'b000;
            ALUControl = 3'b111;
		    if(GT == 0) begin
				PCWrite = 1'b1;
			end
            // Default
            IRWrite = 1'b0;
            MemADD = 2'b00;
            RegAWrite = 1'b0;
            RegBWrite = 1'b0;
            RegWrite = 1'b0;
            RegDest = 3'b000;
            RegData = 4'b0000;
            XCHGRegWrite = 1'b0;
            MFH = 1'b0;
            MuxHiLo = 1'b0;
            MuxHi = 1'b0;
            MuxLo = 1'b0;
            MULT_OP = 1'b0;
            DIV_OP = 1'b0;
            Reg_HI_Write = 1'b0;
            Reg_Lo_Write = 1'b0;
            MemWriteRead = 1'b0;
            RegALUOutWrite = 1'b0;
            estado = WAIT;
        end
        BGT_2ND_CLOCK: begin
            // Alteradas
			PCSource = 3'b100;
			ALUSrcA = 2'b0;
			ALUSrcB = 3'b000;
            ALUControl = 3'b111;
		    if(GT == 1) begin
				PCWrite = 1'b1;
			end
            // Default
            IRWrite = 1'b0;
            MemADD = 2'b00;
            RegAWrite = 1'b0;
            RegBWrite = 1'b0;
            RegWrite = 1'b0;
            RegDest = 3'b000;
            RegData = 4'b0000;
            XCHGRegWrite = 1'b0;
            MFH = 1'b0;
            MuxHiLo = 1'b0;
            MuxHi = 1'b0;
            MuxLo = 1'b0;
            MULT_OP = 1'b0;
            DIV_OP = 1'b0;
            Reg_HI_Write = 1'b0;
            Reg_Lo_Write = 1'b0;
            MemWriteRead = 1'b0;
            RegALUOutWrite = 1'b0;
            estado = WAIT;
        end
        WAIT: begin
            estado = FETCH_1ST_CLOCK;
        end
	endcase
end
endmodule
