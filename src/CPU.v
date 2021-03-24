module CPU (clock, reset, estado, AluResult, MuxAluSrcAOut, MuxAluSrcBOut, Opcode, MemData, funct, RegPCOut, RegAOut, RegAInput,
RegBInput, MuxRegDataOut, MuxRegDestOut, RegWrite, RegALUOutOut);

input clock;
input reset;

output wire [5:0]estado;

wire[2:0] PCSource;
wire[31:0] MuxPCSourceOut;

output wire[31:0] AluResult;

wire ALUSrcA;
output wire [31:0] MuxAluSrcAOut;

wire[2:0] ALUSrcB;
output wire [31:0] MuxAluSrcBOut;
wire [31:0] SignExtend1632Out;
wire [31:0] ShiftLeftOut;

wire RegAWrite;
output wire[31:0] RegAInput;
output wire[31:0] RegAOut;

wire RegBWrite;
output wire[31:0] RegBInput;
wire[31:0] RegBOut;

wire RegPCWrite;
wire[31:0] RegPCInput;
output wire[31:0] RegPCOut;

wire RegEPCWrite;
wire[31:0] RegEPCInput;
wire[31:0] RegEPCOut;

wire RegALUOutWrite;
wire[31:0] RegALUOutInput;
output wire[31:0] RegALUOutOut;

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

output wire RegWrite;
wire[4:0] RS;
wire[4:0] RT;
output wire[4:0] MuxRegDestOut;
output wire[31:0] MuxRegDataOut;

wire[4:0] Immediate;
wire[4:0] Shamt;
wire AmtSrc;
wire [4:0] MuxAmtSrcOut;

wire Zero;
wire EQ;
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
assign SignExtend1_32Out = {31'b0, LT};

wire[31:0] RegShiftOut;
wire[31:0] LoadSizeOut;
wire[31:0] ShiftLeft16Out;
wire[3:0] RegData;

wire ShiftSrc;
wire[31:0] MuxShiftSrcOut;

wire[2:0] RegDest;

wire LoadIR;
output wire [5:0] Opcode;
wire [15:0] Offset;

wire MemWriteRead;
output wire[31:0] MemData;
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
wire [31:0] JumpAddress;

output wire [5:0] funct;
wire[31:0] OffsetExtendido;
wire[31:0] OffsetExtendidoLeft2;

assign funct = Offset[5:0];
assign SignExtend1632Out = {{17{Offset[15]}}, Offset[14:0]};
assign JumpAddress = {RegPCOut[31:28], RS[4:0], RT[4:0], Offset[15:0], 2'b0};
assign OffsetExtendido = {{17{Offset[15]}}, Offset[14:0]};
assign OffsetExtendidoLeft2 = OffsetExtendido << 2;

// Registradores
Registrador A(clock, reset, RegAWrite, RegAInput, RegAOut);
Registrador B(clock, reset, RegBWrite, RegBInput, RegBOut);
Registrador PC(clock, reset, RegPCWrite, MuxPCSourceOut, RegPCOut);
Registrador EPC(clock, reset, RegEPCWrite, RegEPCInput, RegEPCOut);
Registrador ALUOut(clock, reset, RegALUOutWrite, AluResult, RegALUOutOut);
Registrador MDR(clock, reset, RegMDRWrite, MemData, RegMDROut);
Registrador HI(clock, reset, RegHIWrite, RegHIInput, RegHIOut);
Registrador LO(clock, reset, RegLOWrite, RegLOInput, RegLOOut);
Registrador XCHG(clock, reset, RegXCHGWrite, RegXCHGInput, RegXCHGOut);

// Provided components
Banco_reg banco_registradores(clock, reset, RegWrite, RS, RT, MuxRegDestOut, MuxRegDataOut, RegAInput, RegBInput);
Instr_Reg registrador_instrucoes(clock, reset, LoadIR, MemData, Opcode, RS, RT, Offset);
Memoria Memoria(MuxMemAddOut, clock, MemWriteRead, SSOutput, MemData);
RegDesloc registrador_deslocamento(clock, reset, ShiftCtrl, MuxAmtSrcOut, MuxShiftSrcOut, RegShiftOut);
ula32 Alu(MuxAluSrcAOut, MuxAluSrcBOut, AluOp, AluResult, Overflow, Negativo, Zero, EQ, GT, LT);

// Muxes
MuxALUSrcA MuxALUSrcA(RegPCOut, RegAOut, ALUSrcA, MuxAluSrcAOut);
MuxALUSrcB MuxALUSrcB(RegBOut, RegMDROut, SignExtend1632Out, ShiftLeftOut, OffsetExtendidoLeft2, OffsetExtendido, ALUSrcB, MuxAluSrcBOut);
MuxAmtSrc MuxAmtSrc(Immediate, Shamt, AmtSrc, MuxAmtSrcOut);
MuxComparatorSrc MuxComparatorSrc(Zero, GT, LT, ComparatorSrc, MuxComparatorSrcOut);
MuxExceptionAddress MuxExceptionAddress(ExceptionAddress, MuxExceptionAddressOut);
MuxHI MuxHI(MultHI, DivHI, HISelector, MuxHIOut);
MuxLO MuxLO(MultLO, DivLO, LOSelector, MuxLOOut);
MuxHILO MuxHILO(RegHIOut, RegLOOut, HILOSelector, MuxHILOOut);
MuxMemAdd MuxMemAdd(RegPCOut, MuxExceptionAddressOut, RegALUOutOut, MemAdd, MuxMemAddOut);
MuxPCSource MuxPCSource(RegPCOut, AluResult, RegEPCOut, RegMDROut, RegALUOutOut, JumpAddress, RegAOut, PCSource, MuxPCSourceOut);
MuxRegData MuxRegData(AluResult, MuxHILOOut, SignExtend1_32Out, RegShiftOut, LoadSizeOut, ShiftLeft16Out, RegXCHGOut, RegAOut, RegALUOutOut, RegData, MuxRegDataOut);
MuxRegDest MuxRegDest(RT, Offset[15:11], RS, RegDest, MuxRegDestOut);
MuxShiftSrc MuxShiftSrc(RegAOut, RegBOut, ShiftSrc, MuxShiftSrcOut);

// Multiplicador e Divisor
divisor divisor(clock, reset, div_start, RegAOut, RegBOut, DivLO, DivHI, div_fim, DividedByZero);
multiplier multiplier(mult_fim, RegAOut, RegBOut, mult_start, clock, MultHI, MultLO, reset);


// LoadSize e StoreSize
loadsize loadsize(
	MemData,
    LSControl,
    LSOutput
);

storesize storesize(
	MemData,
	SSInput,
    SSControl,
    SSOutput
);

// Controle
Controle Controle (
    clock,
    reset,
    Opcode,
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
    MemWriteRead,
    RegALUOutWrite,
    Overflow,
    funct,
    mult_fim,
    div_fim,
    EQ,
    GT
);


endmodule