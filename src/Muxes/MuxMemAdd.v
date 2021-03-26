module MuxMemAdd (
    input wire[31:0] PC,
    input wire[31:0] ExceptionAddress,
    input wire[31:0] ALUOut,
    input wire[31:0] ALURegOut,
    input wire[31:0] RegAOut,
    input wire [2:0] MemAdd,
	output reg[31:0] MuxMemAddOut
);
always @(*) begin
	case(MemAdd)
		3'b000:
			MuxMemAddOut <= PC;
		3'b001:
			MuxMemAddOut <= ExceptionAddress;
		3'b010:
			MuxMemAddOut <= ALUOut;
		3'b011:
			MuxMemAddOut <= ALURegOut;
		3'b100:
			MuxMemAddOut <= RegAOut;
	endcase
end
endmodule
