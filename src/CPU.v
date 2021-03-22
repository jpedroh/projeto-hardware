module CPU (clock, reset);

input clock;
input reset;

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

endmodule