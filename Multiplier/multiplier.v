module divisor(
	input clock,
	input reset,
	input start,
	input [31:0] operando1,
	input [31:0] operando2,
	output [31:0] hi,
	output [31:0] lo,
	output fim
);

reg ativo;
reg [4:0] cicloAtual;
reg [64:0] A;
reg [64:0] S;
reg [64:0] P;

wire [64:0] soma = P + {A, 33'd0};
wire [64:0] sub = P + {S, 33'd0};

assign fim = ~ativo;
assign hi = P[64:33];
assign lo = P[32:1];

always @(posedge clock, posedge reset) begin
	if (reset) begin

	end
	else if (start) begin
		if (ativo) begin
			if (P[1:0] == 2'b01) begin
				P <= soma;
			end
			if (P[1:0] == 2'b10) begin
				P <= sub;
			end			
			P <= P >>> 1;
			if (!cicloAtual) begin
				ativo <= 0;
			end
			cicloAtual <= cicloAtual - 5'd1;
		end
		else begin
			A <= operando1;
			S <= -operando1;
			P <= {{32'b0, operando2},1'b0};
			cicloAtual <= 5'd31;
			ativo <= 1;
		end
	end
end

endmodule
	
