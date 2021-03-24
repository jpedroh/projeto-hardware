module MuxRegData (
    input wire[31:0] ALUOut,
    input wire[31:0] MuxHILOOut,
    input wire[31:0] SignExtend1_32Out,
    input wire[31:0] RegShiftOut,
    input wire[31:0] LoadSizeOut,
    input wire[31:0] ShiftLeft16Out,
    input wire[31:0] XCHGRegOut,
    input wire[31:0] RegAOut,
	input wire[31:0] RegALUOutOut,
    input wire[3:0] RegData,
	output reg[31:0] MuxRegDataOut
);
always @(*) begin
	case(RegData)
		4'b0000:
			MuxRegDataOut <= RegALUOutOut;
		4'b0001:
			MuxRegDataOut <= MuxHILOOut;
		4'b0010:
			MuxRegDataOut <= SignExtend1_32Out;
		4'b0011:
			MuxRegDataOut <= RegShiftOut;
		4'b0100:
			MuxRegDataOut <= LoadSizeOut;
		4'b0101:
			MuxRegDataOut <= ShiftLeft16Out;
		4'b0110:
			MuxRegDataOut <= 32'd227;
		4'b0111:
			MuxRegDataOut <= XCHGRegOut;
		4'b1000:
			MuxRegDataOut <= RegAOut;
		4'b1001:
			MuxRegDataOut <= RegALUOutOut;
	endcase
end
endmodule
