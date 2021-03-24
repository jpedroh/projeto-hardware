module multiplier(fim,operand1,operando2,start,clock, hi, lo, reset); // P

   input [31:0] operand1, operando2;
   input start, clock, reset;
   output fim;
   output hi;
   output lo;

   reg [63:0] product; //registrador que guarda as operacoes
   reg [31:0] hi;
   reg [31:0] lo;
   reg fim;
   reg [5:0] cicloAtual; 
	wire aux = !cicloAtual; //cabo que sinaliza o fim
   reg lostbit;
   
   initial cicloAtual = 0; //comeca com 0 ciclos e vai ate 32

   always @( posedge clock ) begin
   
	   if (reset) begin //reset que limpa os registradores internos
		product = 63'b0;
		hi = 31'b0;
		lo = 31'b0;
		cicloAtual = 6'b0;
		lostbit = 0;
	end

	   if( aux && start ) begin //"inicializador" que comeca os valores

        cicloAtual = 32;
        product = { 32'd0, operando2 };
        lostbit = 0;
        
     end else if( cicloAtual ) begin

	     case ( {product[0],lostbit} ) //case com o P[1:0]
		     2'b01: product[63:32] = product[63:32] + operand1; // P + A
		     2'b10: product[63:32] = product[63:32] - operand1; // P + S
        endcase

	     lostbit = product[0]; //salva o sinal ultimo bit q vai ser perdido no shift right
	     product = { product[63], product[63:1] }; //faz o shift right salvando o sinal
        cicloAtual = cicloAtual - 1; //decrementa o ciclo
	     hi = product[63:32]; //pega os primeiros 32 bits do produto
	     lo = product[31:0]; // pega os ultimos 32 bits do produto
	     if (cicloAtual == 0) begin
			fim = 1;
		end
     end
   end

endmodule
