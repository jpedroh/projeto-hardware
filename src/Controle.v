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
    input wire funct
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
parameter ADDI_2ND_CLOCK = 6'b001001;
parameter EXCECAO = 6'b111111;
// OPCODES
parameter JUMP_OPCODE = 6'b000010;
parameter JAL_OPCODE = 6'b000011;
parameter ADDI_OPCODE =6'b001000;

// FUNCT                
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
parameter MULT = 6'b011000;
parameter DIV = 6'b011010;

reg [5:0] MULT_DIV_COUNTER; 

initial begin
    estado = FETCH_1ST_CLOCK;
    MULT_DIV_COUNTER = 6'd31;
end

always @(posedge clock) begin
	case(estado)
        FETCH_1ST_CLOCK: begin
            // Alteradas
            PCSource = 3'b001;
            PCWrite = 1'b1;
            MemADD = 2'b00;
            MemWriteRead = 1'b0;
            IRWrite = 1'b0;
            ALUControl = 3'b001;
            ALUSrcB = 3'b011;
            ALUSrcA = 1'b0;

            // Inalteradas
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
            RegALUOutWrite=1'b0;

            estado = FETCH_2ND_CLOCK;
            end
        FETCH_2ND_CLOCK: begin
            PCWrite = 1'b0;
            IRWrite = 1'b0;
            MemADD = 2'b00;
            MemWriteRead = 1'b0;
            PCSource = 3'b000;
            ALUControl = 3'b001;
            ALUSrcB = 3'b011;
            ALUSrcA = 1'b0;
            // Inalteradas
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
            RegALUOutWrite=1'b0;

            estado = FETCH_3RD_CLOCK;
            end
        FETCH_3RD_CLOCK: begin
            PCWrite = 1'b0;
            IRWrite = 1'b1;
            MemADD = 2'b00;
            MemWriteRead = 1'b0;
            PCSource = 3'b000;
            ALUControl = 3'b001;
            ALUSrcB = 3'b011;
            ALUSrcA = 1'b0;
            // Inalteradas
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
            RegALUOutWrite=1'b0;

            estado = DECODE;
            end
        DECODE: begin
            ALUControl = 3'b001;
            ALUSrcB = 3'b100;
            ALUSrcA = 1'b0;
            RegAWrite = 1'b1;
            RegBWrite = 1'b1;
            RegALUOutWrite = 1'b1;
            // Inalteradas
            PCWrite=1'b0;
            IRWrite=1'b0;
            MemADD=2'b00;
            PCSource=3'b000;
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
                        RegALUOutWrite=1'b0;
                        estado = ADD_SUB_AND_2ND_CLOCK;
						end
                    SUB: begin
                        ALUControl = 3'b010;
                        ALUSrcB = 3'b000;
                        ALUSrcA = 1'b1;
                        estado = ADD_SUB_AND_2ND_CLOCK;
                        end
                    AND: begin
                        ALUControl = 3'b011;
                        ALUSrcB = 3'b000;
                        ALUSrcA = 1'b1;
                        estado = ADD_SUB_AND_2ND_CLOCK;
                        end
                    JR: begin
                        PCWrite=1'b1;
                        PCSource = 3'b001;
                        ALUSrcA = 1'b1;
                        ALUControl = 3'b000;
                        estado = FETCH_1ST_CLOCK;
                        end
                    SLT: begin
                        RegWrite = 1'b1;
                        RegDest = 3'b001;
                        RegData = 4'b0010;
                        ALUSrcB = 3'b000;
                        ALUSrcA = 1'b1;
                        ALUControl = 3'b111;
                        estado = FETCH_1ST_CLOCK;
                        end
                    BREAK: begin
                        PCWrite=1'b1;
                        PCSource = 3'b001;
                        ALUControl = 3'b010;
                        ALUSrcB = 3'b011;
                        ALUSrcA = 1'b1;
                        estado = FETCH_1ST_CLOCK;
                        end
                    RTE: begin
                        PCWrite=1'b1;
                        PCSource = 3'b010;
                        estado = FETCH_1ST_CLOCK;
                        end
                    XCHG: begin
                        RegWrite =1'b1;
                        XCHGRegWrite=1'b1;
                        RegDest = 3'b000;
                        RegData = 4'b1000;
                        estado = FETCH_1ST_CLOCK;
                        end
                    MFH: begin
                        RegWrite =1'b1;
                        RegDest = 3'b001;
                        RegData = 4'b0001;
                        MuxHiLo = 1'b0;
                        estado = FETCH_1ST_CLOCK;
                        end
                    MFLO: begin
                        RegWrite =1'b1;
                        RegDest = 3'b001;
                        RegData = 4'b0001;
                        MuxHiLo = 1'b1;
                        estado = FETCH_1ST_CLOCK;
                        end
					MULT: begin
						if (MULT_DIV_COUNTER == 0) begin
							MULT_DIV_COUNTER = 6'd31;
							estado = FETCH_1ST_CLOCK;
							Reg_HI_Write=1'b1;
							Reg_Lo_Write=1'b1;
							MuxHi = 0;
							MuxLo = 0;
						end
						else begin
							MULT_OP = 1;
							estado = MULT;
							MULT_DIV_COUNTER = MULT_DIV_COUNTER - 1;
						end
					end
					DIV: begin
						if (MULT_DIV_COUNTER == 0) begin
							MULT_DIV_COUNTER = 6'd31;
							estado = FETCH_1ST_CLOCK;
							Reg_HI_Write=1'b1;
							Reg_Lo_Write=1'b1;
							MuxHi = 1;
							MuxLo = 1;
						end
						else begin
							DIV_OP = 1;
							estado = DIV;
							MULT_DIV_COUNTER = MULT_DIV_COUNTER - 1;
						end
					end	
                endcase
            end else if (Opcode == JUMP_OPCODE) begin
                PCWrite=1'b1;
                PCSource=3'b000;
                estado = FETCH_1ST_CLOCK;               
            end else if (Opcode == JAL_OPCODE) begin
                ALUControl = 3'b001;
                ALUSrcB = 3'b011;
                ALUSrcA = 1'b0;
                estado = JAL_2ND_CLOCK;
            end else if (Opcode == ADDI_OPCODE) begin
                ALUControl = 3'b001;
                ALUSrcB = 3'b010;
                ALUSrcA = 1'b1;
                // Inalteradas
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
                RegALUOutWrite=1'b0;
                estado = ADDI_2ND_CLOCK;
            end
            end
        ADD_SUB_AND_2ND_CLOCK: begin
            if(ALUOverflow) begin
                estado = EXCECAO;
            end else begin
                RegWrite=1'b1;
                RegDest = 3'b001;
                RegData = 4'b0000;
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
                estado=1'b0;
                MemWriteRead=1'b0;
                RegALUOutWrite=1'b0;
                estado = FETCH_1ST_CLOCK;
            end
			end
        XCHG_2ND_CLOCK: begin
            RegWrite=1'b1;
            RegDest = 3'b100;
            RegData = 4'b0111;
            estado = FETCH_1ST_CLOCK;
            end
        JAL_2ND_CLOCK: begin
            PCWrite=1'b1;
            RegWrite=1'b1;
            RegDest = 3'b010;
            RegData = 4'b0000;
            PCSource = 3'b000;
            estado = FETCH_1ST_CLOCK;
            end
        ADDI_2ND_CLOCK: begin
            RegWrite = 1'b1;
            RegDest = 3'b001;
            RegData = 4'b0000;
            estado = FETCH_1ST_CLOCK;
        end
	endcase
end
endmodule
