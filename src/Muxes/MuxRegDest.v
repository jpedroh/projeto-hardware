module MuxRegDest (
    input wire[4:0] RT,
    input wire[4:0] RD,
    input wire[4:0] RS,
    input wire[2:0] RegDest,
	output reg[4:0] MuxRegDestOut
);
always @(*) begin
	case(RegDest)
		3'b000:
			MuxRegDestOut <= RT;
		3'b001:
			MuxRegDestOut <= RD;
    	3'b010:
			MuxRegDestOut <= 5'd31;
		3'b011:
			MuxRegDestOut <= 5'd29;
    	3'b100:
			MuxRegDestOut <= RS;
	endcase
end
endmodule 






