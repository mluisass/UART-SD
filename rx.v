module rx(serial,clock,leds,segmentoD, segmentoE);

input serial, clock;
wire serial;
output reg [7:0] leds;
output reg [6:0] segmentoE;
output reg [6:0] segmentoD;

parameter [2:0]espera_start_bite=0, armazenando=1, Led=2, limpa=3,carrega=4,mostra=5;
integer  count=0;
integer  contador=0;
reg [7:0] aux;
reg [3:0] data;
reg [2:0] estado=espera_start_bite;

always @(negedge clock) 
    begin
        case(estado)
        espera_start_bite:
            begin
                if(serial==0)
                begin 
                    estado<=armazenando;
                end
            end
        armazenando:
            begin
                count<=count+1;
                if(count==1)
                begin
                    contador<=contador+1;
                    aux[contador]<=serial;
                    if(contador==7)
                      begin
						     estado<=Led;
						     leds<=aux;
                       count<=0;
					     end
                    count<=0;
                end
            end 
        Led:
            begin 
                if(leds[7:4]==3'b0001)
                begin
                    estado<=limpa;
                end
                if(leds[7:4]==3'b0010)
                begin
                    estado<=carrega;
                end
                if(leds[7:4]==3'b0100)
                begin
                    estado<=mostra;
                end
            end
        limpa:
            begin
                segmentoE <= 7'b1111111;
                segmentoD <= 7'b1111111;
                contador<=0;
                estado<=espera_start_bite;
                //leds=8'b00000000;
            end
        carrega:
            begin
                data<=leds[3:0];
                contador<=0;
                estado<=espera_start_bite;
                //leds=8'b00000000;
            end
        mostra:
            begin
                case(data)
                4'b0000 :
                    begin      	//Hexadecimal 0
                    segmentoE <= 7'b0000001;
                    segmentoD <= 7'b0000001;
                    end   
                 4'b0001 :
                    begin    		//Hexadecimal 1
                    segmentoE <= 7'b0000001;
                    segmentoD <= 7'b1001111 ;
                    end
                4'b0010 :
                    begin  		// Hexadecimal 2
                    segmentoE <= 7'b0000001;
                    segmentoD <= 7'b0010010 ;
                    end 
                4'b0011 :
                    begin 		// Hexadecimal 3
                    segmentoE <= 7'b0000001;
                    segmentoD <= 7'b0000110 ;
                    end
                4'b0100 :
                    begin		// Hexadecimal 4
                    segmentoE <= 7'b0000001;
                    segmentoD <= 7'b1001100 ;
                    end
                4'b0101 :
                    begin		// Hexadecimal 5
                    segmentoE <= 7'b0000001;
                    segmentoD <= 7'b0100100 ;
                    end  
                4'b0110 :
                    begin		// Hexadecimal 6
                    segmentoE <= 7'b0000001;
                    segmentoD <= 7'b0100000 ;
                    end
                4'b0111 :
                    begin		// Hexadecimal 7
                    segmentoE <= 7'b0000001;
                    segmentoD <= 7'b0001111;
                    end         
                4'b1000 :
                    begin     		 //Hexadecimal 8
                    segmentoE <= 7'b0000001 ;
                    segmentoD <= 7'b0000000 ;
                    end
                4'b1001 :
                    begin    		//Hexadecimal 9
                    segmentoE <= 7'b0000001 ;
                    segmentoD <= 7'b0000100 ;
                    end
                4'b1010 :
                    begin  		// Hexadecimal 10
                    segmentoE <= 7'b1001111 ;
                    segmentoD <= 7'b0000001 ;
                    end 
                4'b1011 :
                    begin 		// Hexadecimal 11
                    segmentoE <= 7'b1001111 ;
                    segmentoD <= 7'b1001111 ;
                    end 
                4'b1100 :
                    begin		// Hexadecimal 12
                    segmentoE <= 7'b1001111 ;
                    segmentoD <= 7'b0010010 ;
                    end 
                4'b1101 :
                    begin		// Hexadecimal 13
                    segmentoE <= 7'b1001111 ;
                    segmentoD <= 7'b0000110 ;
                    end
                4'b1110 :
                    begin		// Hexadecimal 14
                    segmentoE <= 7'b1001111 ;
                    segmentoD <= 7'b1001100 ;
                    end
                4'b1111 :
                    begin		// Hexadecimal 15
                    segmentoE <= 7'b1001111 ;
                    segmentoD <= 7'b0100100 ;
                    end
                endcase
                contador<=0;
                estado<=espera_start_bite;
                //leds=8'b0000000;
            end
    endcase
    end
endmodule