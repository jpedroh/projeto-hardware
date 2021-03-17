module loadsize(
	input wire [31:0] entrada,
	input wire [1:0] control,
	output reg [31:0] saida
)

always @(*) begin
	if (control == 2'b00) begin //word
		saida = entrada;
	end
	if (control == 2'b01) begin //halfword
		saida = {16'b0, entrada[15:0]}
	end
	if (control == 2'b10) begin //byte
		saida = {24'b0, entrada[7:0]}
	end
		
end


endmodule
