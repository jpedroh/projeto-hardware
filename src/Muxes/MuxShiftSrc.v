module MuxShiftSrc (
    input wire[31:0] RegA,
    input wire[31:0] RegB,
    input wire ShiftSrc,
	output reg[31:0] MuxShiftSrcOut
);	
always @(*) begin
	case(ShiftSrc)
		1'b0:
			MuxShiftSrcOut <= RegB;
		1'b1:
			MuxShiftSrcOut <= RegA;
	endcase
end
endmodule
