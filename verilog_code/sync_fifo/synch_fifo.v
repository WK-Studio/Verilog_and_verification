'include "sram.v"

module synch_fifo #(parameter FIFO_PTR   = 4,
                              FIFO_WIDTH = 32,
                              FIFO_DEPTH = 16)
       (fifo_clk,
        rstb,
        fifo_wren,
        fifo_wrdata,
        fifo_rren,
        fifo_rdata,
        fifo_full,
        fifo_empty,
        fifo_room_avail,
        fifo_data_avail);

// ***************************************************************
input                         fifo_clk;
input                         rstb;
input                         fifo_wren;
input   [FIFO_WIDTH - 1:0]    fifo_wrdata;
input                         fifo_rden;

output  [FIFO_WIDTH - 1:0]    fifo_rddata;
output                        fifo_full;
output                        fifo_empty;
output  [FIFO_PTR:0]          fifo_room_avail;
output  [FIFO_PTR:0]          fifo_data_avail;

localparam    FIFO_DEPTH_MINUS1 = FIFO_DEPTH - 1;

// ***************************************************************
reg     [FIFO_PTR - 1:0]      wr_ptr, wr_ptr_nxt;
reg     [FIFO_PTR - 1:0]      rd_ptr, rd_ptr_nxt;
reg     [FIFO_PTR:0]          num_entries, num_entries_nxt;
reg                           fifo_full, fifo_empty;
wire                          fifo_full_nxt, fifo_empty_nxt;
reg     [FIFO_PTR:0]          fifo_room_avail;
wire    [FIFO_PTR:0]          fifo_room_avail_nxt;
wire    [FIFO_PTR:0]          fifo_data_avail;

// write-pointer control logic
// ***************************************************************
always@(*)
    begin
        wr_ptr_nxt = wr_ptr;
        if (fifo_wren)
            begin
                if (wptr == FIFO_DEPTH_MINUS1) // wptr at end position
                    wr_ptr_nxt = 'd0; // write ptr rollback to 0
                else
                    wr_ptr_nxt = wr_ptr + 1'b1;
            end
    end


// read-pointer control logic
// ***************************************************************
always@(*)
    begin
        rd_ptr_nxt = rd_ptr;
        if (fifo_rden)
            begin
                if (rptr == FIFO_DEPTH_MINUS1) // rptr at end position
                    rd_ptr_nxt = 'd0; // read ptr rollback to 0
                else
                    rd_ptr_nxt = rd_ptr + 1'b1;
            end
    end


// calculate number of occupied entries in the FIFO control logic
// ***************************************************************
always@(*)
    begin
        num_entries_nxt = num_entries;

        if (fifo_wren && fifo_rden) // no change to num_entries
            num_entries_nxt = num_entries;
        else if (fifo_wren)
            num_entries_nxt = num_entries + 1'b1;
        else if (fifo_rden)
            num_entries_nxt = num_entries - 1'b1;
        else
            num_entries_nxt = num_entries;
    end

assign fifo_full_nxt   = (num_entries_nxt == FIFO_DEPTH);
assign fifo_empty_nxt  = (num_entries_nxt == 'd0);
assign fifo_data_avail = num_entries;
assign fifo_room_avail_nxt = (FIFO_DEPTH - num_entries_nxt);

// ***************************************************************
always@(posedge fifo_clk or negedge rstb)
    begin
        if(!rstb) // reset fifo
            begin
                wr_ptr          <= 'd0;
                rd_ptr          <= 'd0;
                num_entries     <= 'd0;
                fifo_full       <= 1'b0;
                fifo_empty      <= 1'b1;
                fifo_room_avail <= FIFO_DEPTH;
            end
        else
            begin 
                wr_ptr          <= wr_ptr_nxt;
                rd_ptr          <= rd_ptr_nxt;
                num_entries     <= num_entires_nxt;
                fifo_full       <= fifo_full_nxt;
                fifo_empty      <= fifo_empty_nxt;
                fifo_room_avail <= fifo_room_avail_nxt;
            end
    end

// FIFO sram memory instantiation
fifo_sram  #(.FIFO_PTR (FIFO_PTR),
             .FIFO_WIDTH (FIFO_WIDTH)) sram0

           (.wrclk  (fifo_clk),
            .wren   (fifo_wren),
            .wptr   (wr_ptr),
            .wrdata (fifo_wrdata),
            .rdclk  (fifo_clk),
            .rden   (fifo_rden),
            .rdptr  (rd_ptr),
            .rdata  (fifo_rddata));

endmodule
