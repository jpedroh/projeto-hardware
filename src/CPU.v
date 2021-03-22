module CPU (clock, reset);

input clock;
input reset;

wire[2:0] PCSource;
wire[31:0] MuxPCSourceOut;

wire[31:0] PlainALUOut;

wire[1:0] ALUSrcA;
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
wire[31:0] RS;
wire[31:0] RT;
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

// Muxes
MuxALUSrcA MuxALUSrcA(RegPCOut, RegAOut, ALUSrcA, MuxAluSrcAOut);
MuxALUSrcB MuxALUSrcB(RegBOut, RegMDROut, SignExtend1632Out, ShiftLeftOut, ALUSrcB, MuxAluSrcBOut);
MuxAmtSrc MuxAmtSrc(Immediate, Shamt, AmtSrc, MuxAmtSrcOut);
MuxComparatorSrc MuxComparatorSrc(Zero, GT, LT, ComparatorSrc, MuxComparatorSrcOut);
MuxExceptionAddress MuxExceptionAddress(ExceptionAddress, MuxExceptionAddressOut);
MuxHI MuxHI(MultHI, DivHI, HISelector, MuxHIOut);
MuxLO MuxLO(MultLO, DivLO, LOSelector, MuxLOOut);
MuxMemAdd MuxMemAdd(RegPCOut, ExceptionAddress, RegALUOutOut, MemAdd, MuxMemAddOut);
MuxPCSource MuxPCSource(RegPCOut, RegALUOutOut, RegEPCOut, RegMDROut, PlainALUOut, PCSource, MuxPCSourceOut);
MuxRegData MuxRegData(PlainALUOut, MuxHILOOut, SignExtend1_32Out, RegShiftOut, LoadSizeOut, ShiftLeft16Out, XCHGRegOut, RegAOut, RegData, MuxRegDataOut);
MuxRegDest MuxRegDest(RTAdd, RDAdd, RSAdd, RegDest, MuxRegDestOut);
MuxShiftSrc MuxShiftSrc(RegAOut, RegBOut, ShiftSrc, MuxShiftSrcOut);

endmodule