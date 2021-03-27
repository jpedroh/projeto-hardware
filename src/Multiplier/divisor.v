module divisor(  
  input clock,  
  input reset,  
  input start,  
  input [31:0] dividendo,  
  input [31:0] divisor,  
  output [31:0] lo,  
  output [31:0] hi,  
  output reg fim,   
  output wire DividedByZero  
);  
  reg ativo; //registrador para determinar se o divisor esta ativo, dependendo do ciclo atual   
  reg [4:0] cicloAtual; //registrador que vai de 31 a 0 para guardar o ciclo atual
  reg [31:0] quociente; //registrador que guarda o quociente atual
  reg [31:0] denominador;//registrador que guarda o divisor para ser usado em uma operacao
  reg [31:0] resto;//registrador que guarda o resto atual
  wire [32:0] sub = { resto[30:0], quociente[31] } - denominador; //operacao feita em um fio, que serve para a divisao  
  assign DividedByZero = !divisor;//se o divisor for 0, !divisor vai ser 1  
  assign lo = quociente; //coloca lo como quociente 
  assign hi = resto; //coloca o hi como resto
  always @(posedge clock,posedge reset) begin  
    if (reset) begin  //reseta todos os registradores caso reset == 1
      ativo <= 0;  
      cicloAtual <= 0;  
      quociente <= 0;  
      denominador <= 0;  
      resto <= 0;  
    end  
    else if(start) begin //so opera se o sinal start for 1
      if (ativo) begin
        if (sub[32] == 0) begin //pega o bit 32 do sub  
          resto <= sub[31:0];//o resto fica como os 32 bits menos significantes de 32
          quociente <= {quociente[30:0], 1'b1}; //faz um shift left no quociente colocando 1 no final
        end  
        else begin  
          resto <= {resto [30:0], quociente[31]};  //pega os 31 bits do resto e concatena com o 31 bit do quociente
          quociente <= {quociente[30:0], 1'b0}; //faz um shift left normal no quociente
        end  
        if (cicloAtual == 0) begin //se chegou no ultimo ciclo
          ativo <= 0; //deixa de ser ativo
          fim <= 1;
        end
        else begin
          fim <= 0;
        end
        cicloAtual <= cicloAtual - 5'd1; //decrementa o ciclo
      end  
      else begin 
        if (fim == 0) begin
          cicloAtual <= 5'd31; //comeca com 31 no ciclo
          quociente = dividendo; //quociente comeca como dividendo (e depende do sinal)
          denominador = divisor; //denominador recebe o divisor (e depende do sinal)
          resto <= 32'b0; //o resto comeca como zero
          ativo <= 1; // seta o ativo como 1
        end
        else begin
          fim = 0;
        end
      end  
    end  
  end  
endmodule   
