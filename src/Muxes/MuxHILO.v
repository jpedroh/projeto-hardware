module MuxHILO (
    input reg[31:0] HI,
    input reg[31:0] LO,
    input wire[1:0] HILO,
	output reg[31:0] MuxHILOOut
);
always @(*) begin
	case(HILO)
		1'b0:
			MuxLOOut <= HI;
		1'b1:
			MuxLOOut <= LO;
	endcase
end
endmodule