module MuxComparatorSrc (
    input wire[1:0] Zero,
    input wire[1:0] GT,
    input wire[1:0] LT,
    input wire[2:0] ComparatorSrc,
	output reg[1:0] MuxComparatorSrcOut
);
always @(*) begin
	case(ComparatorSrc)
		2'b00:
			MuxComparatorSrcOut <= LT;
		2'b01:
			MuxComparatorSrcOut <= GT;
		2'b10:
			MuxComparatorSrcOut <= Zero;
	endcase
end
endmodule