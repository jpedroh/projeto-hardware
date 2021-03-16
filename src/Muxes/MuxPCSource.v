module MuxPCSource (
    input wire[31:0] PC,
    input wire[31:0] ALU ,
    input wire[31:0] EPC,
    input reg[31:0] MemDataReg,
    input wire[31:0] ALUOut,
    input wire[4:0] PCSource ,
	    output reg[31:0] MuxPCSourceOut
);
always @(*) begin
	case(PCSource)
		1'b000:
			MuxPCSourceOut <= PC;
    1'b001:
			MuxPCSourceOut <= ALU;
		1'b010:
			MuxPCSourceOut <= EPC;
    1'b011:
			MuxPCSourceOut <= MemDataReg;
		1'b100:
			MuxPCSourceOut <= ALUOut;
        
	endcase
end






