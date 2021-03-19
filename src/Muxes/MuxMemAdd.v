module MuxMemAdd (
    input wire[31:0] PC,
    input wire[31:0] ExceptionAddress,
    input wire[31:0] ALUOut,
    input wire [1:0] MemAdd,
	output reg[31:0] MuxMemAddOut
);
always @(*) begin
	case(MemAdd)
		2'b00:
			MuxMemAddOut <= PC;
		2'b01:
			MuxMemAddOut <= ExceptionAddress;
		2'b10:
			MuxMemAddOut <= ALUOut;
	endcase
end
endmodule
