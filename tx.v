module tx(botao, clock, reset, entrada, saida);

input botao, clock, reset;
input [7:0] entrada;
output reg saida;//acho que isso tem que ser wire 

parameter [2:0] espera_apertar = 0, armazena = 1, espera_soltar = 2, transmite = 3;

integer pulsos = 0;

reg [2:0] estado_atual = espera_apertar;
reg [9:0] data;

initial saida = 1;

always @(negedge clock or posedge reset) 
begin
    if(reset)
    begin
        estado_atual<=espera_apertar;
        pulsos<=0;
    end
    else 
    begin 
        case (estado_atual)
            espera_apertar: 
                begin 
                    if(botao==0)
                        estado_atual<=armazena;
                end
            armazena:
                begin
                    data[0]<=0; // start bit
                    data[8:1]<=entrada;
                    data[9]<=1; // end bit
                    estado_atual<=espera_soltar;
                end
            espera_soltar:
                begin
                    if(botao==1) 
                        estado_atual<=transmite;
                end
            transmite:  
                begin
                    pulsos<=pulsos + 1;
                    saida<=data[pulsos];
                    if(pulsos==9)
                    begin
                        estado_atual<=espera_apertar;
                        pulsos<=0;
                        saida<=1;
                    end
                end    
        endcase
    end
end
endmodule 