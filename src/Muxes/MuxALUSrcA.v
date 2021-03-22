module MuxALUSrcA (
    input wire[31:0] PC,
    input wire[31:0] RegDataA,
    input wire ALUSrcA,
	output reg[31:0] MuxALUSrcAOut
);
always @(*) begin
	case(ALUSrcA)
		1'b0:
			MuxALUSrcAOut <= PC;
		1'b1:
			MuxALUSrcAOut <= RegDataA;
	endcase
end
endmodule
