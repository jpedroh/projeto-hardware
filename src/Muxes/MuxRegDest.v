module MuxRegDest (
    input reg[4:0] InstrunctionRegister0,
    input reg[4:0] InstrunctionRegister1,
    input reg[4:0] InstrunctionRegister4,
    input wire[4:0] RegDest ,
	    output reg[31:0] MuxRegDest
);
always @(*) begin
	case(RegDest)
		1'b000:
			MuxALUSrcBOut <= InstrunctionRegister0;
		1'b001:
			MuxALUSrcBOut <= InstrunctionRegister1;
    1'b010:
			MuxALUSrcBOut <= 32'd31;
		1'b011:
			MuxALUSrcBOut <= 32'd29;
    1'b100:
			MuxALUSrcBOut <= InstrunctionRegister4;
	endcase
end






