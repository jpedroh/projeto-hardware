module SignExtend132 (
input reg MuxComparatorSrcOut,
output reg[31:0] SignExtend132Out
);

always @(*) begin
	SignExtend132Out <= {{31'd0},MuxComparatorSrcOut};
end

endmodule
