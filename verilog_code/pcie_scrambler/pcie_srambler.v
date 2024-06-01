module scrambler_8bits
       (clk,
       rstb,
       data_in,
       k_in,
       disab_scram,
       data_out,
       k_out);

input clk;
input rstb;
input [7:0] data_in;
input k_in;
input disab_scarm;
output [7:0] data_out;
output k_out;

localparam LFSR_INIT = 16'hFFFF;

reg [15:0] lfsr, lfsr_nxt;
wire [15:8] lfsr_int;

assign lfsr_int[0] = lfsr[8];
assign lfsr_int[1] = lfsr[9];
assign lfsr_int[2] = lfsr[10];
assign lfsr_int[3] = lfsr[8] ^ lfsr[12];
assign lfsr_int[4] = lfsr[8] ^ lfsr[9] ^ lfsr[12];
assign lfsr_int[5] = lfsr[8] ^ lfsr[10] ^ lfsr[13];

endmodule
