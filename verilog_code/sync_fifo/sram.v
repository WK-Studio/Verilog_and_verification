module fifo_sram #(parameter FIFO_PTR   = 10,
                             FIFO_WIDTH = 8)
       (wrclk,
        wren,
        wptr,
        wrdata,
        rdclk,
        rden,
        rdptr,
        rddata);

input                        wrclk;
input                        wren;
input  [(FIFO_PTR - 1):0]    wrptr;
input  [(FIFO_WIDTH - 1):0]  wrdata;

input                        rdclk;
input                        rden;
input  [(FIFO_PTR - 1):0]      rdptr;
output [(FIFO_WIDTH - 1):0]  rddata;

local_param FIFO_DEPTH = (2 ** FIFO_PTR);

reg [(FIFO_WIDTH-1):0] ram [0:(FIFO_DEPTH - 1)];
reg [(FIFO_WIDTH-1):0] rdata;

always@(posedge wrclk)
    begin
        if (wren)
            ram[wptr] = wrdata;
    end


always@(posedge rdclk)
    begin
        if (rden)
            rdata = ram[rdptr];
    end
endmodule
