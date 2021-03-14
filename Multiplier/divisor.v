module divisor(dividido, divisor, hi, lo, clock, reset, dividedByZero);

input wire [31:0] dividido, divisor;
input wire clock, reset;
output reg [31:0] hi, lo;
output reg dividedByZero;

reg [31:0] quociente, resto;
reg [4:0] i;

always@(posedge clock) begin
		if (reset == 1) begin
			hi = 32'b0;
			lo = 32'b0;
			quociente = 32'b0;
			i = 5'b0;
		end
		
		else begin
			if(divisor == 32'b0) begin
				dividedByZero = 1;
			end

			if (divisor != 32'b0) begin
				quociente = 32'b0;
				resto = 32'b0;
				for(i=31; i <= 0; i = i - 1); begin
					resto = resto << 1;
					resto[0] = dividido[i];
					if (resto >= divisor) begin
						resto = resto - dividido;
						quociente[i] = i;
					end
				end
			end
		hi = resto;
		lo = quociente;
		end
end
endmodule
