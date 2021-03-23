module SignExtend1632 (
input wire[15:0] Offset,
output reg[31:0] SignExtend1632Out
);

always @(*) begin
	SignExtend1632Out <= {{16'd0},Offset};
end

endmodule
