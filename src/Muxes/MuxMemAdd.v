module MuxMemAdd (
    input wire[31:0] PC,
    input reg[31:0] ExceptionAddress,
    input reg[31:0] ALUOut,
    input wire[2:0] MemAdd,
	output reg[31:0] MuxMemAddOut
);
always @(*) begin
	case(MemAdd)
		1'b00:
			MuxMemAddOut <= PC;
		1'b01:
			MuxMemAddOut <= ExceptionAddress;
		1'b10:
			MuxMemAddOut <= ALUOut;
	endcase
end
endmodule