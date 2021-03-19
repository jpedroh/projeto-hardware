module MuxHILO (
    input wire[31:0] HI,
    input wire[31:0] LO,
    input wire HILO,
	output reg[31:0] MuxHILOOut
);
always @(*) begin
	case(HILO)
		1'b0:
			MuxHILOOut <= HI;
		1'b1:
			MuxHILOOut <= LO;
	endcase
end
endmodule
