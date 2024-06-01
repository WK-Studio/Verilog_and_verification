// sync_fifo
// width: 32
// depth: 31
// fifo empty: can't be read
// fifo full: can't be write

module sync_fifo (
    input rst_n,
    input clk,
    input wr_en,
    input [31:0] din,
    input rd_en,    
    output [31:0] dout,
    output reg fifo_empty,
    output reg fifo_full
);

reg [31:0] mem [31:0];
reg [31:0] w_ram_line;
reg [$clog2(32)-1:0] fifo_rptr;
reg [$clog2(32)-1:0] fifo_wptr;

assign dout = mem[0];

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
        fifo_rptr <= 1'b0;
    else // reset fifo
        fifo_rptr <= wptr;
end

always @(*)
begin
    case ({wr_en, rd_en})
        2'b10: fifo_wptr = fifo_rptr + 1; // wr_en: 1, rd_en: 0
        2'b01: fifo_wptr = fifo_rptr - 1; // wr_en: 0. rd_en: 1
        default: fifo_wptr = fifo_rptr;
    endcase
end

always @(posedge clk or negedge rst_n)
begin
    case ({wr_en, rd_en})
        2'b11: w_ram_line = 32'd0; w_ram_line[rptr-1] = 1'd1; 
        2'b10: w_ram_line = 32'd0; w_ram_line[rptr] = 1'd1;
        default: w_ram_line = 32'd0;
    endcase
end

genvar i;

// handle mem[0] ~ mem[30]
generate
    for (i=0; i<31 ; i=i+1)
    begin
        always @(posedge clk or negedge rst_n)
        begin
            if (!rst_n)
                mem[i] <= 1'b0;
            else
                begin
                    if (w_ram_line[i])
                        mem[i] <= din;
                    else if (rd_en)
                        mem[i] <= mem[i+1];
                end
        end
    end
endgenerate

// handle mem[31]
always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    else
    begin
        if (w_ram_line[31])
            mem[31] <= din;
        else if (rd_en)
            mem[31] <= 0;
    end
end

// handle fifo empty
always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
        fifo_empty <= 1'b0;
    else if (fifo_wptr == 'd0)
        fifo_empty <= 1'b1;
    else
        fifo_empty <= 1'b0;
end

// handle fifo full
always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
        fifo_full <= 1'b0;
    else if (fifo_wptr == 'd31)
        fifo_full <= 1'b1;
    else
        fifo_full <= 1'b0;
end

wire [7:0] mem_0;
wire [7:0] mem_1;
wire [7:0] mem_2;
wire [7:0] mem_3;
wire [7:0] mem_4;
wire [7:0] mem_5;
wire [7:0] mem_6;
wire [7:0] mem_7;
wire [7:0] mem_8;
wire [7:0] mem_9;
wire [7:0] mem_10;
wire [7:0] mem_11;
wire [7:0] mem_12;
wire [7:0] mem_13;
wire [7:0] mem_14;
wire [7:0] mem_15;
wire [7:0] mem_16;
wire [7:0] mem_17;
wire [7:0] mem_18;
wire [7:0] mem_19;
wire [7:0] mem_20;
wire [7:0] mem_21;
wire [7:0] mem_22;
wire [7:0] mem_23;
wire [7:0] mem_24;
wire [7:0] mem_25;
wire [7:0] mem_26;
wire [7:0] mem_27;
wire [7:0] mem_28;
wire [7:0] mem_29;
wire [7:0] mem_30;
wire [7:0] mem_31;

assign mem_0 = mem[0];
assign mem_1 = mem[1];
assign mem_2 = mem[2];
assign mem_3 = mem[3];
assign mem_4 = mem[4];
assign mem_5 = mem[5];
assign mem_6 = mem[6];
assign mem_7 = mem[7];
assign mem_8 = mem[8];
assign mem_9 = mem[9];
assign mem_10 = mem[10];
assign mem_11 = mem[11];
assign mem_12 = mem[12];
assign mem_13 = mem[13];
assign mem_14 = mem[14];
assign mem_15 = mem[15];
assign mem_16 = mem[16];
assign mem_17 = mem[17];
assign mem_18 = mem[18];
assign mem_19 = mem[19];
assign mem_20 = mem[20];
assign mem_21 = mem[21];
assign mem_22 = mem[22];
assign mem_23 = mem[23];
assign mem_24 = mem[24];
assign mem_25 = mem[25];
assign mem_26 = mem[26];
assign mem_27 = mem[27];
assign mem_28 = mem[28];
assign mem_29 = mem[29];
assign mem_30 = mem[30];
assign mem_31 = mem[31];

endmodule //sync_fifo