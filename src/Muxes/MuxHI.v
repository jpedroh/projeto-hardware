module MuxHI (
    input reg[31:0] MultHI,
    input reg[31:0] DivHI,
    input wire[1:0] HI,
	output reg[31:0] MuxHIOut
);
always @(*) begin
	case(HI)
		1'b0:
			MuxHIOut <= MultHI;
		1'b1:
			MuxHIOut <= DivHI;
	endcase
end
endmodule