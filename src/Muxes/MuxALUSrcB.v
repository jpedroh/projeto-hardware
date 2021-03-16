module MuxALUSrcB (
    input reg[31:0] RegDataB,
    input reg[31:0] MemDataReg
    input wire[31:0] SignExtend1632Out,
    input wire[31:0] ShiftLeftOut     
    input wire[4:0] ALUSrcB,
	output reg[31:0] MuxALUSrcBOut
);
always @(*) begin
	case(ALUSrcB)
		1'b000:
			MuxALUSrcBOut <= RegDataB;
		1'b001:
			MuxALUSrcBOut <= MemDataReg;
        	1'b010:
			MuxALUSrcBOut <= SignExtend1632Out;
		1'b011:
			MuxALUSrcBOut <= 32'd4;
        	1'b100:
			MuxALUSrcBOut <= ShiftLeftOut;
	endcase
end
