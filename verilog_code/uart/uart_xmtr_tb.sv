`include "uart_xmtr.v"

module tb_uart8_xmtr();
    parameter word_size = 4'h8;
    reg [word_size-1 : 0] Data_bus;
    reg Byte_ready, Load_XMT_datareg, T_byte, rst_b;
    wire Set_Byte_ready, Serial_out;
    wire Clock;

    reg [5 : 0] k;
    reg [word_size+1 : 0] Serial_test;

    // instantiation
    UART_XMTR DUT 
    (
        .Serial_out(Serial_out),
        .Data_bus(Data_bus),
        .Load_XMT_datareg(Load_XMT_datareg),
        .Byte_ready(Byte_ready),
        .T_byte(T_byte),
        .Clock(Clock),
        .rst_b(rst_b)
    );

    // instantiation
    defparam tb_clk.Latency = 1'd0;
    defparam tb_clk.Offset = 3'd5;
    defparam tb_clk.Pulse_Width = 3'd5;
    Clock_prog tb_clk
    (
        .Clock(Clock)
    );

    // start simulation
    initial #200 $finsih;
    initial begin
        #5 rst_b = 1'd0;
        #5 rst_b = 1'd1;
    end
    initial begin
        #40 Byte_ready = 1'd1;
        #10 Byte_ready = 1'd0;
    end
    initial begin
        #10 Load_XMT_datareg = 1'd0;
        #10 Load_XMT_datareg = 1'd1;
        #10 Load_XMT_datareg = 1'd0;
    end
    initial begin
        #90 Load_XMT_datareg = 1'd1;
        #10 Load_XMT_datareg = 1'd0;
    end
    initial begin
        #120 Load_XMT_datareg = 1'd1;
        #10 Load_XMT_datareg = 1'd0;
    end

    always @ (posedge Clock or negdege rst_b) begin
        if (rst_b == 1'd0) 
            Serial_test <= 1'd0;
        else
            Serial_test <= {Serial_out, Serial_test[word_size + 1: 1]};
    end

    wire [word_size - 1 : 0] sent_word = Serial_test[word_size:1];

    

endmodule