module ShiftLeft2 (
    input wire[31:0] ShiftLeft2In,
	output reg[31:0] ShiftLeft2Out
);
always @(*) begin
    ShiftLeft2Out <= ShiftLeft2In << 2;
end
endmodule