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
    output reg AmtSrc,
    output reg ShftSrc,
    output reg [2:0]RegShftCtrl,
    output reg RegMDRWrite,
    output reg [1:0] LSControl,
    output reg [1:0] SSControl,
    output reg [1:0] ExceptionAddress,
    output reg RegEPCWrite,
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
parameter SLTI_2ND_CLOCK = 15;
parameter SLT_2ND_CLOCK = 16;
parameter SLL_2ND_CLOCK = 17;
parameter SLLV_2ND_CLOCK = 18;
parameter SRA_2ND_CLOCK = 19;
parameter SRAV_2ND_CLOCK = 20;
parameter SRL_2ND_CLOCK = 21;
parameter SHIFT_3RD_CLOCK = 22;
parameter LB_2ND_CLOCK = 23;
parameter LB_3RD_CLOCK = 24;
parameter LB_4TH_CLOCK = 25;
parameter LH_2ND_CLOCK = 26;
parameter LH_3RD_CLOCK = 27;
parameter LH_4TH_CLOCK = 28;
parameter LW_2ND_CLOCK = 29;
parameter LW_3RD_CLOCK = 30;
parameter LW_4TH_CLOCK = 31;
parameter SB_2ND_CLOCK = 32;
parameter SB_3RD_CLOCK = 33;
parameter SB_4TH_CLOCK = 34;
parameter SH_2ND_CLOCK = 35;
parameter SH_3RD_CLOCK = 36;
parameter SH_4TH_CLOCK = 37;
parameter SW_2ND_CLOCK = 38;
parameter SW_3RD_CLOCK = 39;
parameter SW_4TH_CLOCK = 40;
parameter EXCEPTION_WAIT = 41;
parameter SEND_EXCEPTION_BYTE_TO_PC = 42;

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
parameter SLTI_OPCODE = 6'b001010;
parameter LUI_OPCODE = 6'b001111;
parameter LB_OPCODE = 6'b100000;
parameter LH_OPCODE = 6'b100001;
parameter LW_OPCODE = 6'b100011;
parameter SB_OPCODE = 6'b101000;
parameter SH_OPCODE = 6'b101001;
parameter SW_OPCODE = 6'b101011;

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
parameter SLL = 6'b000000;
parameter SLLV = 6'b000100;
parameter SRA = 6'b000011;
parameter SRAV = 6'b000111;
parameter SRL = 6'b000010;

initial begin
    estado = FETCH_1ST_CLOCK;
end

always @(posedge clock) begin
	if (reset) begin
		//Alteradas
        RegWrite = 1'b1;
        RegDest = 3'b011;
        RegData = 4'b0110;
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
        estado = FETCH_1ST_CLOCK;
	end			
	else begin
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
                        ALUControl = 3'b111;
                        ALUSrcA = 1'b1;
                        ALUSrcB = 3'b000;
                        // Default
                        PCWrite = 1'b0;
                        IRWrite = 1'b0;
                        MemADD = 2'b00;
                        PCSource = 3'b000;
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

                        estado = SLT_2ND_CLOCK;
                        end
                    BREAK: begin
                        PCWrite = 1'b1;
                        PCSource = 3'b001;
                        ALUSrcA = 1'b0;
                        ALUSrcB = 3'b011;
                        ALUControl = 3'b010;
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
                        estado = FETCH_1ST_CLOCK;
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
                        estado = XCHG_2ND_CLOCK;
                        end
                    MFHI: begin
                        RegWrite =1'b1;
                        RegDest = 3'b001;
                        RegData = 4'b0001;
                        MuxHiLo = 1'b0;
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
                    MFLO: begin
                        RegWrite =1'b1;
                        RegDest = 3'b001;
                        RegData = 4'b0001;
                        MuxHiLo = 1'b1;
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
                    SLL: begin
                        ShftSrc = 1'b0;
                        RegShftCtrl = 3'b001;
                        //Inalteradas
                        PCWrite=1'b0;
                        IRWrite=1'b0;
                        MemADD=2'b00;
                        PCSource=3'b000;
                        ALUControl = 3'b000;
                        ALUSrcB = 3'b000;
                        ALUSrcA = 1'b0;
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
                        MemWriteRead=1'b0;
                        RegALUOutWrite=1'b0;
                        estado = SLL_2ND_CLOCK;
					end
			        SLLV: begin
                        ShftSrc = 1'b1;
                        RegShftCtrl = 3'b001;
                        //Inalteradas
                        PCWrite=1'b0;
                        IRWrite=1'b0;
                        MemADD=2'b00;
                        PCSource=3'b000;
                        ALUControl = 3'b000;
                        ALUSrcB = 3'b000;
                        ALUSrcA = 1'b0;
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
                        MemWriteRead=1'b0;
                        RegALUOutWrite=1'b0;
                        estado = SLLV_2ND_CLOCK;
					end
			        SRA: begin
                        ShftSrc = 1'b0;
                        RegShftCtrl = 3'b001;
                        //Inalteradas
                        PCWrite=1'b0;
                        IRWrite=1'b0;
                        MemADD=2'b00;
                        PCSource=3'b000;
                        ALUControl = 3'b000;
                        ALUSrcB = 3'b000;
                        ALUSrcA = 1'b0;
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
                        MemWriteRead=1'b0;
                        RegALUOutWrite=1'b0;
                        estado = SRA_2ND_CLOCK;
					end
			        SRAV: begin
                        ShftSrc = 1'b1;
                        RegShftCtrl = 3'b001;
                        //Inalteradas
                        PCWrite=1'b0;
                        IRWrite=1'b0;
                        MemADD=2'b00;
                        PCSource=3'b000;
                        ALUControl = 3'b000;
                        ALUSrcB = 3'b000;
                        ALUSrcA = 1'b0;
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
                        MemWriteRead=1'b0;
                        RegALUOutWrite=1'b0;
                        estado = SRAV_2ND_CLOCK;
					end
			        SRL: begin
                        ShftSrc = 1'b0;
                        RegShftCtrl = 3'b001;
                        //Inalteradas
                        PCWrite=1'b0;
                        IRWrite=1'b0;
                        MemADD=2'b00;
                        PCSource=3'b000;
                        ALUControl = 3'b000;
                        ALUSrcB = 3'b000;
                        ALUSrcA = 1'b0;
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
                        MemWriteRead=1'b0;
                        RegALUOutWrite=1'b0;
                        estado = SRL_2ND_CLOCK;
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
            end else if (Opcode == SLTI_OPCODE) begin
                ALUControl = 3'b111;
                ALUSrcA = 1'b1;
                ALUSrcB = 3'b111;
                // Default
                PCWrite = 1'b0;
                IRWrite = 1'b0;
                MemADD = 2'b00;
                PCSource = 3'b000;
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

                estado = SLTI_2ND_CLOCK;
            end else if (Opcode == LUI_OPCODE) begin
                RegWrite = 1'b1;
                RegDest = 3'b000;
                RegData = 4'b0101;
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
            end else if (Opcode == LB_OPCODE) begin
                MemADD = 2'b10;
                MemWriteRead = 1'b0;
                ALUControl = 3'b000;
                ALUSrcB = 3'b111;
                ALUSrcA = 1'b1;
                RegALUOutWrite = 1'b1;
                // Default
                PCWrite = 1'b0;
                IRWrite = 1'b0;
                PCSource = 3'b000;
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
                estado = LB_2ND_CLOCK;
            end else if (Opcode == LH_OPCODE) begin
                MemADD = 2'b10;
                MemWriteRead = 1'b0;
                ALUControl = 3'b000;
                ALUSrcB = 3'b111;
                ALUSrcA = 1'b1;
                RegALUOutWrite = 1'b1;
                // Default
                PCWrite = 1'b0;
                IRWrite = 1'b0;
                PCSource = 3'b000;
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
                estado = LH_2ND_CLOCK;
            end else if (Opcode == LW_OPCODE) begin
                MemADD = 2'b10;
                MemWriteRead = 1'b0;
                ALUControl = 3'b001;
                ALUSrcB = 3'b111;
                ALUSrcA = 1'b1;
                RegALUOutWrite = 1'b1;
                // Default
                PCWrite = 1'b0;
                IRWrite = 1'b0;
                PCSource = 3'b000;
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
                estado = LW_2ND_CLOCK;
            end else if (Opcode == SB_OPCODE) begin
                MemADD = 2'b10;
                MemWriteRead = 1'b0;
                ALUControl = 3'b000;
                ALUSrcB = 3'b111;
                ALUSrcA = 1'b1;
                RegALUOutWrite = 1'b1;
                // Default
                PCWrite = 1'b0;
                IRWrite = 1'b0;
                PCSource = 3'b000;
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
                estado = SB_2ND_CLOCK;
            end else if (Opcode == SH_OPCODE) begin
                MemADD = 2'b10;
                MemWriteRead = 1'b0;
                ALUControl = 3'b000;
                ALUSrcB = 3'b111;
                ALUSrcA = 1'b1;
                RegALUOutWrite = 1'b1;
                // Default
                PCWrite = 1'b0;
                IRWrite = 1'b0;
                PCSource = 3'b000;
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
                estado = SH_2ND_CLOCK;
            end else if (Opcode == SW_OPCODE) begin
                MemADD = 2'b10;
                MemWriteRead = 1'b0;
                ALUControl = 3'b001;
                ALUSrcB = 3'b111;
                ALUSrcA = 1'b1;
                RegALUOutWrite = 1'b1;
                // Default
                PCWrite = 1'b0;
                IRWrite = 1'b0;
                PCSource = 3'b000;
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
                SSControl = 2'b00;
                estado = SW_2ND_CLOCK;
            end else begin
                // OPCODE INEXISTENTE
                MemADD = 2'b01;
                MemWriteRead = 1'b0;
                ALUControl = 3'b010;
                ALUSrcB = 3'b011;
                ALUSrcA = 1'b0;
                ExceptionAddress = 2'b00;
				RegEPCWrite = 1'b1;
                // Default
                PCWrite = 1'b0;
                IRWrite = 1'b0;
                PCSource = 3'b000;
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
                RegALUOutWrite = 1'b0;
                ExceptionAddress = 2'b00;
                RegEPCWrite = 1'b0;
                estado=EXCEPTION_WAIT;
            end
        end
        ADD_SUB_AND_2ND_CLOCK: begin
            if(ALUOverflow == 0) begin
                RegWrite = 1'b1;
                RegDest = 3'b001;
                RegData = 4'b1001;
				estado = WAIT;
				//
                ExceptionAddress = 2'b00;
                MemADD = 2'b00;
                ALUControl = 3'b000;
                ALUSrcB = 3'b000;
                ALUSrcA = 1'b0;
				RegEPCWrite = 1'b0;
			end else begin
                ExceptionAddress = 2'b01;
                MemADD = 2'b01;
                ALUControl = 3'b010;
                ALUSrcB = 3'b011;
                ALUSrcA = 1'b0;
				RegEPCWrite = 1'b1;
				estado = EXCEPTION_WAIT;
				//
				RegDest = 3'b000;
				RegWrite = 1'b0;
				RegData = 4'b0000;
			end
            RegWrite = 1'b1;
            RegDest = 3'b001;
            RegData = 4'b1001;
            // Inalteradas
            PCWrite=1'b0;
            IRWrite=1'b0;
            PCSource=3'b000;
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
        XCHG_2ND_CLOCK: begin
            RegWrite = 1'b1;
            RegDest = 3'b100;
            RegData = 4'b0111;
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
            if(ALUOverflow == 0) begin
                RegWrite = 1'b1;
                RegDest = 3'b000;
                RegData = 4'b0000;
				estado = FETCH_1ST_CLOCK;
				//
                ExceptionAddress = 2'b00;
                MemADD = 2'b00;
                ALUControl = 3'b000;
                ALUSrcB = 3'b000;
                ALUSrcA = 1'b0;
				RegEPCWrite = 1'b0;
			end else begin
                ExceptionAddress = 2'b01;
                MemADD = 2'b01;
                ALUControl = 3'b010;
                ALUSrcB = 3'b011;
                ALUSrcA = 1'b0;
				RegEPCWrite = 1'b1;
				estado = EXCEPTION_WAIT;
				//
				RegDest = 3'b000;
				RegWrite = 1'b0;
				RegData = 4'b0000;
			end
            // Default
            PCWrite = 1'b0;
            IRWrite = 1'b0;
            PCSource = 3'b000;
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
				estado = FETCH_1ST_CLOCK;
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
				estado = FETCH_1ST_CLOCK;
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
        SLTI_2ND_CLOCK: begin
            RegWrite = 1'b1;
            RegDest = 3'b000;
            RegData = 4'b0010;
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
        SLT_2ND_CLOCK: begin
            RegWrite = 1'b1;
            RegDest = 3'b001;
            RegData = 4'b0010;
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
        SLTI_2ND_CLOCK: begin
            RegWrite = 1'b1;
            RegDest = 3'b000;
            RegData = 4'b0010;
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
        SLL_2ND_CLOCK: begin
            AmtSrc = 1'b0;
            RegShftCtrl = 3'b010;
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
            RegWrite = 1'b0;
            RegDest = 3'b000;
            RegData = 4'b0000;
            estado = SHIFT_3RD_CLOCK;
	    end
	    SLLV_2ND_CLOCK: begin
            AmtSrc = 1'b1;
            RegShftCtrl = 3'b010;
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
            estado = SHIFT_3RD_CLOCK;
        end
	    SRA_2ND_CLOCK: begin
            AmtSrc = 1'b0;
            RegShftCtrl = 3'b100;
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
            estado = SHIFT_3RD_CLOCK;
        end
	    SRAV_2ND_CLOCK: begin
            AmtSrc = 1'b1;
            RegShftCtrl = 3'b100;
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
            estado = SHIFT_3RD_CLOCK;
        end
	    SRL_2ND_CLOCK: begin
            AmtSrc = 1'b0;
            RegShftCtrl = 3'b011;
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
            estado = SHIFT_3RD_CLOCK;
        end
	    SHIFT_3RD_CLOCK: begin
            RegWrite = 1'b1;
            RegDest = 3'b001;
            RegData = 4'b0011;
            // Default
            AmtSrc = 1'b0;
            RegShftCtrl = 3'b000;
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
        LB_2ND_CLOCK: begin
            MemADD = 2'b11;
            // Default
            PCWrite = 1'b0;
            IRWrite = 1'b0;
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
            estado = LB_3RD_CLOCK;
        end
        LB_3RD_CLOCK: begin
            MemADD = 2'b11;
            RegMDRWrite = 1'b1;
            // Default
            PCWrite = 1'b0;
            IRWrite = 1'b0;
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
            estado = LB_4TH_CLOCK;
        end
        LB_4TH_CLOCK: begin
            LSControl = 2'b11;
            RegWrite = 1'b1;
            RegDest = 3'b000;
            RegData = 4'b0100;
            // Default
            MemADD = 2'b00;
            RegMDRWrite = 1'b0;
            PCWrite = 1'b0;
            IRWrite = 1'b0;
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
        LH_2ND_CLOCK: begin
            MemADD = 2'b11;
            // Default
            PCWrite = 1'b0;
            IRWrite = 1'b0;
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
            estado = LH_3RD_CLOCK;
        end
        LH_3RD_CLOCK: begin
            MemADD = 2'b11;
            RegMDRWrite = 1'b1;
            // Default
            PCWrite = 1'b0;
            IRWrite = 1'b0;
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
            estado = LH_4TH_CLOCK;
        end
        LH_4TH_CLOCK: begin
            LSControl = 2'b01;
            RegWrite = 1'b1;
            RegDest = 3'b000;
            RegData = 4'b0100;
            // Default
            MemADD = 2'b00;
            RegMDRWrite = 1'b0;
            PCWrite = 1'b0;
            IRWrite = 1'b0;
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
        LW_2ND_CLOCK: begin
            MemADD = 2'b11;
            // Default
            PCWrite = 1'b0;
            IRWrite = 1'b0;
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
            estado = LW_3RD_CLOCK;
        end
        LW_3RD_CLOCK: begin
            MemADD = 2'b11;
            RegMDRWrite = 1'b1;
            // Default
            PCWrite = 1'b0;
            IRWrite = 1'b0;
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
            estado = LW_4TH_CLOCK;
        end
        LW_4TH_CLOCK: begin
            LSControl = 2'b00;
            RegWrite = 1'b1;
            RegDest = 3'b000;
            RegData = 4'b0100;
            // Default
            MemADD = 2'b00;
            RegMDRWrite = 1'b0;
            PCWrite = 1'b0;
            IRWrite = 1'b0;
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
        SB_2ND_CLOCK: begin
            MemADD = 2'b11;
            // Default
            PCWrite = 1'b0;
            IRWrite = 1'b0;
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
            estado = SB_3RD_CLOCK;
        end
        SB_3RD_CLOCK: begin
            MemADD = 2'b11;
            RegMDRWrite = 1'b1;
            // Default
            PCWrite = 1'b0;
            IRWrite = 1'b0;
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
            estado = SB_4TH_CLOCK;
        end
        SB_4TH_CLOCK: begin
            SSControl = 2'b10;
            MemADD = 2'b11;
            MemWriteRead = 1'b1;
            // Default
            RegWrite = 1'b0;
            RegDest = 3'b000;
            RegData = 4'b0000;
            MemADD = 2'b00;
            RegMDRWrite = 1'b0;
            PCWrite = 1'b0;
            IRWrite = 1'b0;
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
            RegALUOutWrite = 1'b0;
            estado = WAIT;
        end
        SH_2ND_CLOCK: begin
            MemADD = 2'b11;
            // Default
            PCWrite = 1'b0;
            IRWrite = 1'b0;
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
            estado = SH_3RD_CLOCK;
        end
        SH_3RD_CLOCK: begin
            MemADD = 2'b11;
            RegMDRWrite = 1'b1;
            // Default
            PCWrite = 1'b0;
            IRWrite = 1'b0;
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
            estado = SH_4TH_CLOCK;
        end
        SH_4TH_CLOCK: begin
            SSControl = 2'b01;
            MemADD = 2'b11;
            MemWriteRead = 1'b1;
            // Default
            RegWrite = 1'b0;
            RegDest = 3'b000;
            RegData = 4'b0000;
            MemADD = 2'b00;
            RegMDRWrite = 1'b0;
            PCWrite = 1'b0;
            IRWrite = 1'b0;
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
            RegALUOutWrite = 1'b0;
            estado = WAIT;
        end
        SW_2ND_CLOCK: begin
            MemADD = 2'b11;
            MemWriteRead = 1'b0;
            SSControl = 2'b00;
            // Default
            PCWrite = 1'b0;
            IRWrite = 1'b0;
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
            RegALUOutWrite = 1'b0;
            estado = SW_3RD_CLOCK;
        end
        SW_3RD_CLOCK: begin
            MemADD = 2'b11;
            RegMDRWrite = 1'b1;
            SSControl = 2'b00;
            MemWriteRead = 1'b0;
            // Default
            PCWrite = 1'b0;
            IRWrite = 1'b0;
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
            RegALUOutWrite = 1'b0;
            estado = SW_4TH_CLOCK;
        end
        SW_4TH_CLOCK: begin
            SSControl = 2'b00;
            MemADD = 2'b11;
            MemWriteRead = 1'b1;
            RegMDRWrite = 1'b0;
            // Default
            RegWrite = 1'b0;
            RegDest = 3'b000;
            RegData = 4'b0000;
            PCWrite = 1'b0;
            IRWrite = 1'b0;
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
            RegALUOutWrite = 1'b0;
            estado = FETCH_1ST_CLOCK;
        end
        EXCEPTION_WAIT: begin
            MemWriteRead = 1'b0;
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
            RegALUOutWrite = 1'b0;
            ExceptionAddress = 2'b00;
            RegEPCWrite = 1'b0;
            estado = SEND_EXCEPTION_BYTE_TO_PC;
        end
        SEND_EXCEPTION_BYTE_TO_PC: begin
            PCWrite = 1'b1;
            PCSource = 3'b101;
            // Default
            MemWriteRead = 1'b0;
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
            RegALUOutWrite = 1'b0;
            ExceptionAddress = 2'b00;
            RegEPCWrite = 1'b0;
            estado = FETCH_1ST_CLOCK;
        end
        WAIT: begin
            estado = FETCH_1ST_CLOCK;
            MemWriteRead = 1'b0;
        end
	endcase
end
end
endmodule
