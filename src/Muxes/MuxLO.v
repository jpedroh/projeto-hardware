module MuxLO (
    input wire[31:0] MultLO,
    input wire [31:0] DivLO,
    input wire LO,
	output reg[31:0] MuxLOOut
);
always @(*) begin
	case(LO)
		1'b0:
			MuxLOOut <= MultLO;
		1'b1:
			MuxLOOut <= DivLO;
	endcase
end
endmodule
