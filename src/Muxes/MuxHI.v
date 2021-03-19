module MuxHI (
    input wire[31:0] MultHI,
    input wire[31:0] DivHI,
    input wire HI,
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
