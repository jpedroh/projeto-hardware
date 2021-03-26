module MuxALUSrcA (
    input wire[31:0] PC,
    input wire[31:0] RegDataA,
	input wire [31:0] RegMDROut,
    input wire [1:0] ALUSrcA,
	output reg[31:0] MuxALUSrcAOut
);
always @(*) begin
	case(ALUSrcA)
		2'b00:
			MuxALUSrcAOut <= PC;
		2'b01:
			MuxALUSrcAOut <= RegDataA;
		2'b10:
			MuxALUSrcAOut <= RegMDROut;
	endcase
end
endmodule
