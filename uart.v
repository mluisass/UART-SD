module uart (in, rst, clock_tx, clock_rx, segD, segE, led, b);
input rst, clock_tx, clock_rx, b;
input [7:0] in;

output [6:0] segD, segE;
output [7:0] led;

wire tx_rx;

tx mod_tx(.botao(b), .entrada(in), .clock(clock_tx), .reset(rst), .saida(tx_rx));
rx mod_rx(.serial(tx_rx), .clock(clock_rx), .leds(led), .segmentoD(segD), .segmentoE(segE));

endmodule