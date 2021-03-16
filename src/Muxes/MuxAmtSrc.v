module MuxAmtSrc (
    input wire[4:0] Immediate,
    input reg[4:0] RegB,
    input wire[1:0] AmtSrc,
	output reg[4:0] MuxAmtSrcOut
);
always @(*) begin
	case(AmtSrc)
		1'b0:
			MuxAmtSrcOut <= Immediate;
		1'b1:
			MuxAmtSrcOut <= RegB;
	endcase
end
endmodule