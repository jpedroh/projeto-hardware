module MuxRegDest (
    input wire[4:0] InstrunctionRegister0,
    input wire[4:0] InstrunctionRegister1,
    input wire[4:0] InstrunctionRegister4,
    input wire[2:0] RegDest ,
	output reg[4:0] MuxRegDestOut
);
always @(*) begin
	case(RegDest)
		3'b000:
			MuxRegDestOut <= InstrunctionRegister0;
		3'b001:
			MuxRegDestOut <= InstrunctionRegister1;
    		3'b010:
			MuxRegDestOut <= 5'd31;
		3'b011:
			MuxRegDestOut <= 5'd29;
    		3'b100:
			MuxRegDestOut <= InstrunctionRegister4;
	endcase
end
endmodule 






