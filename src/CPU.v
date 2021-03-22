module CPU (clock, reset, estado);

input clock;
input reset;

output wire [5:0]estado;

wire[2:0] PCSource;
wire[31:0] MuxPCSourceOut;

wire[31:0] AluResult;

wire ALUSrcA;
wire [31:0] MuxAluSrcAOut;

wire[2:0] ALUSrcB;
wire [31:0] MuxAluSrcBOut;
wire [31:0] SignExtend1632Out;
wire [31:0] ShiftLeftOut;

wire RegAWrite;
wire[31:0] RegAInput;
wire[31:0] RegAOut;

wire RegBWrite;
wire[31:0] RegBInput;
wire[31:0] RegBOut;

wire RegPCWrite;
wire[31:0] RegPCInput;
wire[31:0] RegPCOut;

wire RegEPCWrite;
wire[31:0] RegEPCInput;
wire[31:0] RegEPCOut;

wire RegALUOutWrite;
wire[31:0] RegALUOutInput;
wire[31:0] RegALUOutOut;

wire RegMDRWrite;
wire[31:0] RegMDRInput;
wire[31:0] RegMDROut;

wire RegHIWrite;
wire[31:0] RegHIInput;
wire[31:0] RegHIOut;

wire RegLOWrite;
wire[31:0] RegLOInput;
wire[31:0] RegLOOut;

wire RegXCHGWrite;
wire[31:0] RegXCHGInput;
wire[31:0] RegXCHGOut;

wire RegWrite;
wire[4:0] RS;
wire[4:0] RT;
wire[4:0] MuxRegDestOut;
wire[31:0] MuxRegDataOut;

wire[4:0] Immediate;
wire[4:0] Shamt;
wire AmtSrc;
wire [4:0] MuxAmtSrcOut;

wire Zero;
wire GT;
wire LT;
wire[1:0] ComparatorSrc;
wire MuxComparatorSrcOut;
wire[1:0] ExceptionAddress;
wire[31:0] MuxExceptionAddressOut;

wire[31:0] MultHI;
wire[31:0] DivHI;
wire HISelector;
wire[31:0] MuxHIOut;

wire[31:0] MultLO;
wire[31:0] DivLO;
wire LOSelector;
wire[31:0] MuxLOOut;

wire [1:0] MemAdd;
wire[31:0] MuxMemAddOut;

wire[31:0] SignExtend1_32Out;
wire[31:0] RegShiftOut;
wire[31:0] LoadSizeOut;
wire[31:0] ShiftLeft16Out;
wire[3:0] RegData;

wire ShiftSrc;
wire[31:0] MuxShiftSrcOut;

wire[4:0] RTAdd;
wire[4:0] RDAdd;
wire[4:0] RSAdd;
wire[2:0] RegDest;

wire LoadIR;
wire [5:0] Opcode;
wire [15:0] Offset;

wire MemWriteRead;
wire[31:0] MemDataOut;
wire [2:0] ShiftCtrl;
wire [2:0] AluOp;

wire div_start;
wire div_fim;
wire DividedByZero;
wire mult_fim;
wire mult_start;

wire HILOSelector;
wire [31:0] MuxHILOOut;

wire [1:0] LSControl;
wire [31:0] LSOutput;

wire [31:0] SSInput;
wire [1:0] SSControl;
wire [31:0] SSOutput;

// Registradores
Registrador A(clock, reset, RegAWrite, RegAInput, RegAOut);
Registrador B(clock, reset, RegBWrite, RegBInput, RegBOut);
Registrador PC(clock, reset, RegPCWrite, RegPCInput, RegPCOut);
Registrador EPC(clock, reset, RegEPCWrite, RegEPCInput, RegEPCOut);
Registrador ALUOut(clock, reset, RegALUOutWrite, RegALUOutInput, RegALUOutOut);
Registrador MDR(clock, reset, RegMDRWrite, RegMDRInput, RegMDROut);
Registrador HI(clock, reset, RegHIWrite, RegHIInput, RegHIOut);
Registrador LO(clock, reset, RegLOWrite, RegLOInput, RegLOOut);
Registrador XCHG(clock, reset, RegXCHGWrite, RegXCHGInput, RegXCHGOut);

// Provided components
Banco_reg banco_registradores(clock, reset, RegWrite, RS, RT, MuxRegDestOut, MuxRegDataOut, RegAInput, RegBInput);
Instr_Reg registrador_instrucoes(clock, reset, LoadIR, MemDataOut, Opcode, RS, RT, Offset);
Memoria Memoria(MuxMemAddOut, clock, MemWriteRead, SSOutput, MemDataOut);
RegDesloc registrador_deslocamento(clock, reset, ShiftCtrl, MuxAmtSrcOut, MuxShiftSrcOut, RegShiftOut);
ula32 Alu(MuxAluSrcAOut, MuxAluSrcBOut, AluOp, AluResult, Overflow, Negativo, Zero, EQ, GT, LT);

// Muxes
MuxALUSrcA MuxALUSrcA(RegPCOut, RegAOut, ALUSrcA, MuxAluSrcAOut);
MuxALUSrcB MuxALUSrcB(RegBOut, RegMDROut, SignExtend1632Out, ShiftLeftOut, ALUSrcB, MuxAluSrcBOut);
MuxAmtSrc MuxAmtSrc(Immediate, Shamt, AmtSrc, MuxAmtSrcOut);
MuxComparatorSrc MuxComparatorSrc(Zero, GT, LT, ComparatorSrc, MuxComparatorSrcOut);
MuxExceptionAddress MuxExceptionAddress(ExceptionAddress, MuxExceptionAddressOut);
MuxHI MuxHI(MultHI, DivHI, HISelector, MuxHIOut);
MuxLO MuxLO(MultLO, DivLO, LOSelector, MuxLOOut);
MuxHILO MuxHILO(RegHIOut, RegLOOut, HILOSelector, MuxHILOOut);
MuxMemAdd MuxMemAdd(RegPCOut, MuxExceptionAddressOut, RegALUOutOut, MemAdd, MuxMemAddOut);
MuxPCSource MuxPCSource(RegPCOut, RegALUOutOut, RegEPCOut, RegMDROut, AluResult, PCSource, MuxPCSourceOut);
MuxRegData MuxRegData(AluResult, MuxHILOOut, SignExtend1_32Out, RegShiftOut, LoadSizeOut, ShiftLeft16Out, RegXCHGOut, RegAOut, RegData, MuxRegDataOut);
MuxRegDest MuxRegDest(RTAdd, RDAdd, RSAdd, RegDest, MuxRegDestOut);
MuxShiftSrc MuxShiftSrc(RegAOut, RegBOut, ShiftSrc, MuxShiftSrcOut);

// Multiplicador e Divisor
divisor divisor(clock, reset, div_start, RegAOut, RegBOut, DivLO, DivHI, div_fim, DividedByZero);
multiplier multiplier(mult_fim, RegAOut, RegBOut, mult_start, clock, MultHI, MultLO, reset);


// LoadSize e StoreSize
loadsize loadsize(
	MemDataOut,
    LSControl,
    LSOutput
);


storesize storesize(
	MemDataOut,
	SSInput,
    SSControl,
    SSOutput
);

wire[31:0] instrucao;

// Controle
Controle Controle (
    clock,
    reset,
    Opcode,
    instrucao,
    RegPCWrite,
    LoadIR,
    MemAdd,
    PCSource,
    AluOp,
    ALUSrcB,
    ALUSrcA,
    RegAWrite,
    RegBWrite,
    RegWrite,
    RegDest,
    RegData,
    RegXCHGWrite,
    MFH,
    HILOSelector,
    HISelector,
    LOSelector,
    mult_start,
    div_start,
    RegHIWrite,
    RegLOWrite,
    estado,
    Overflow
);


endmodule