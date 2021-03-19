module MuxExceptionAddress (
	input wire[1:0] ExceptionAddress,
	output reg[31:0] MuxExceptionAddressOut
);
always @(*) begin
	case(ExceptionAddress)
		2'b00:
			MuxExceptionAddressOut <= 32'd253;
		2'b01:
			MuxExceptionAddressOut <= 32'd254;
		2'b10:
			MuxExceptionAddressOut <= 32'd255;
	endcase
end
endmodule
