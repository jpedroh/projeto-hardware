module MuxPCSource (
    input wire[31:0] PC,
    input wire[31:0] ALU ,
    input wire[31:0] EPC,
    input wire[31:0] MemDataReg,
    input wire[31:0] ALUOut,
    input wire[2:0] PCSource ,
	    output reg[31:0] MuxPCSourceOut
);
always @(*) begin
	case(PCSource)
		3'b000:
			MuxPCSourceOut <= PC;
    		3'b001:
			MuxPCSourceOut <= ALU;
		3'b010:
			MuxPCSourceOut <= EPC;
    		3'b011:
			MuxPCSourceOut <= MemDataReg;
		3'b100:
			MuxPCSourceOut <= ALUOut;
	endcase
end
endmodule 






