module MuxComparatorSrc (
    input wire Zero,
    input wire GT,
    input wire LT,
    input wire[1:0] ComparatorSrc,
	output reg MuxComparatorSrcOut
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
