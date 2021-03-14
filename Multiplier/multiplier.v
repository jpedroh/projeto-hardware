module multiplier(operand1, operand2, hi, lo, clock, reset);
input wire [31:0] operand1, operand2;
input wire clock, reset;
output reg [31:0] hi, lo;

reg [64:0] A, S, P; // A = adicao, S = subtracao P = produto
reg [63:0] Paux; // P auxiliar na hora de montar o P
reg [31:0] operand1compl2; //operando1 negativo
reg [4:0] i; // i para o for

//algoritmo baseado no algoritmo de multiplicacao de booth

always@(posedge clock) begin
	A = {operand1, 33'b0}; // A = operando1 + zeros
	operand1compl2 = ~operand1 + 1; //pega o negativo do operando1
	S = {operand1compl2, 33'b0}; // S = negativo_operando1 + zeros
	Paux = {32'b0, operand2}; //zeros + operando2 
	P = {Paux, 1'b0}; //Paux + 0 no fim
	if (reset == 1)begin //limpando os registradores
		A = 65'b0;
		S = 65'b0;
		P = 65'b0;
		Paux = 64'b0;
		operand1compl2 = 32'b0;
		i = 5'b0;
		hi = 32'b0;
		lo = 32'b0;
	end 
	else begin
		
	for(i=0; i < 32; i = i + 1) begin //itera 32 vezes pq e um numero de 32 bits
		case(P[1:0]) //faz um case com os 2 ultimos bits de P
				2'b00: begin 
					P = {P[64],P[64:1]}; //faz o shift right preservando o sinal
					end
				2'b01: begin
					P = P + A; //soma P + A
					P = {P[64], P[64:1]}; //faz o shift right preservando o sinal
					end
				2'b10:	begin
					P = P + S; // soma P + S
					P = {P[64],P[64:1]}; //faz o shift right preservando o sinal
					end
				2'b11: begin
					P = {P[64],P[64:1]}; //faz o shift right preservando o sinal
					end
				endcase
		end
	assign hi = P[64:33]; //hi e os 32 primeiros bits do produto
	assign lo = P[33:1]; // e lo e os 32 bits seguintes
	end

	
end
endmodule
	
			
	
