`timescale 1ns/1ps
`include "sync_fifo.v"
`define clk_period 20

program automatic sync_fifo_tb;
    reg clk;
    reg rst_n;
    reg [31:0] data;
    reg rdreq;
    reg wrreq;

    sync_fifo myfifo(
        .clk(clk),
        .rst_n(rst_n),
        .din(data),
        .wr_en(wrreq && !myfifo.fifo_full),
        .rd_en(rdreq && !myfifo.fifo_empty));

    initial clk = 1;

    always #(`clk_period/2) clk = ~clk;

    initial
    begin 
        rst_n = 0;
        #30;
        rst_n = 1;
    end

    integer i;
    initial
    begin
        wrreq = 0;
        data = 0;
        rdreq = 0;
        # (`clk_period*20);
        fork
            begin
                for (int i=0; i<=99; i=i+1)
                begin
                    @(posedge clk);
                    #0.1;
                    wrreq = 1;
                    data = i;
                end

                @(posedge clk);
                #0.1;
                wrreq = 0;
            end
            begin
                #100;
                for (int i=0; i<=99; i=i+1)
                begin
                    @(posedge clk);
                    #0.1;
                    rdreq = 1; 
                end
                @(posedge clk);
                #0.1;
                wrreq = 0;
            end
        join
        #200;
        $finish();
    end

    initial
    begin
        $vcdpluson();
    end
    
endprogram

