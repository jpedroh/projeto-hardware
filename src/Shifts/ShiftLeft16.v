module ShiftLeft16 (
    input wire[15:0] ShiftLeft16In,
	output reg[31:0] ShiftLeft16Out
);
always @(*) begin
    ShiftLeft16Out <= ShiftLeft16In << 16;
end
endmodule