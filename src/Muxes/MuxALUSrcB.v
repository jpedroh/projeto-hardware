module MuxALUSrcB (
    input wire[31:0] RegDataB,
    input wire[31:0] MemDataReg,
    input wire[31:0] SignExtend1632Out,
    input wire[31:0] ShiftLeftOut,
	input wire[31:0] OffsetExtendidoLeft2,
    input wire[2:0] ALUSrcB,
	output reg[31:0] MuxALUSrcBOut
);
always @(*) begin
	case(ALUSrcB)
		3'b000:
			MuxALUSrcBOut <= RegDataB;
		3'b001:
			MuxALUSrcBOut <= MemDataReg;
        3'b010:
			MuxALUSrcBOut <= SignExtend1632Out;
		3'b011:
			MuxALUSrcBOut <= 32'd4;
        3'b100:
			MuxALUSrcBOut <= ShiftLeftOut;
        3'b101:
			MuxALUSrcBOut <= OffsetExtendidoLeft2;
	endcase
end
endmodule 
