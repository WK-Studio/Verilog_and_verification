module UART_XMTR#(parameter word_size = 8)( // Size of data, e.g. 8-bits
    output Serial_out,                      // Serial output to data channel
    input [word_size - 1 : 0] Data_bus,     // Host data bus containing data word
    input Load_XMT_datareg,                 // Used by host to load the data register
    input Byte_ready,                       // Used by host to signal ready
    input T_byte,                           // Used by host to signal start of tranmission
    input Clock,                            // Bit clock of the transmitter
    input rst_b);                           // Resets internal registers, loads the XMT_shftreg with ones

    Control_Unit M0
    (
        .Load_XMT_DR(Load_XMT_DR),
        .Load_XMT_shftreg(Load_XMT_shftreg),
        .start(start),
        .shift(shift),
        .clear(clear),
        .Load_XMT_datareg(Load_XMT_datareg),
        .Byte_ready(Byte_ready),
        .T_byte(T_byte),
        .BC_lt_BCmax(BC_lt_BCmax),
        .Clock(Clock),
        .rst_b(rst_b)
    );

    Datapath_Unit M1
    (
        .Serial_out(Serial_out),
        .BC_lt_BCmax(BC_lt_BCmax),
        .Data_bus(Data_bus),
        .Load_XMT_DR(Load_XMT_DR),
        .Load_XMT_shftreg(Load_XMT_shftreg),
        .start(start),
        .clear(clear),
        .Clock(Clock),
        .rst_b(rst_b)
    );

endmodule

module Control_Unit#(
    parameter  one_hot_count = 3,           // Number of one-hot states
               state_count = one_hot_count, // Number of bits in state register
               size_bit_count = 3,          // Size of the bit counter, e.g., 4. Must count to word_size + 1
               idle = 3'b001,               // one-hot state encoding
               waiting = 3'b010,
               sending = 3'b100,
               all_ones = 9'b1_1111_1111)(  // Word + 1 extra bit
    output reg Load_XMT_DR,                 // Loads Data_Bus into XMT_datareg
    output reg Load_XMT_shtreg,             // Loads XMT_datareg into XMT_shftreg
    output reg start,                       // Launches shifting of bits in XMT_shftreg
    output reg shift,                       // Shifts bits in XMT_shftreg
    output reg clear,                       // Clear bit_counter after last bit is sent
    input      Load_XMT_datareg,            // Asserts Load_XMT_DR in state idle
    input      Byte_ready,                  // Asserts Load_XMT_shftreg in staet idle
    input      T_byte,                      // Asserts start signal in state waiting
    input      BC_lt_BCmax,                 // Indicates status of bit counter
    input      Clock,
    input      rst_b);

    reg [state_count - 1 : 0] state, state_nxt; // State machine controller

    always @ (state, Load_XMT_datereg, Byte_ready, T_byte, BC_it_BCmax) begin : Output_and_next_state
        Load_XMT_DR = 0;
        Load_XMT_shftreg = 0;
        start = 0;
        shift = 0;
        clear = 0;
        next_state = idle;
        
        case (state)
            idle: begin 
                if (Load_XMT_datareg == 1'b1) begin
                    Load_XMT_DR = 1;
                    nxt_state = idle;
                end
                else if (Byte_ready == 1'b1) begin
                    Load_XMT_shftreg = 1;
                    nxt_state = waiting; 
                end
            end
            waiting: begin 
                if (T_byte == 1'b1) begin
                    start = 1;
                    next_state = sending;
                end
                else next_state = waiting;
            end
            sending: begin
                if (BC_lt_BCmax) begin
                    shift = 1;
                    next_state = sending;
                end
                else begin
                    clear = 1;
                    next_state = idle;
                end
            end
            default: next_state = idle;
        endcase
    end

    always @ (posedge Clock, negedge rst_b) begin : State_Transitions
        if (rst_b == 1'b0) begin
            state <= idle;
        end
        else begin
            state <= next_state;
        end
    end
endmodule

module Datapath_unit#(
    parameter word_size = 8,
              size_bit_count = 3,
              all_ones = {(word_size + 1){1'b1}})(
    output    Serial_out,
              BC_lt_BCmax,
    input     [word_size - 1: 0] Data_bus,
    input     Load_XMT_DR,
    input     Load_XMT_shftreg,
    input     start,
    input     shift,
    input     clear,
    input     Clock,
    input     rst_b);

    reg [word_size-1: 0]    XMT_datareg; // Transmit Data Register
    reg [word_size: 0]      XMT_shftreg; // Transmit Shift Register {data, start bit}

    reg [size_bit_count: 0] bit_count;   // Counts the bits that are transmitted 
    
    assign Serial_out = XMT_shftreg[0];
    assign BC_lt_BCmax = (bit_count < word_size + 1);

    always @ (posedge Clock, negedge rst_b) begin
        if (Load_XMT_DR == 1'b1) begin
            XMT_shft_reg <= all_ones;
            bit_count <= 0;
        end
        else begin : Register_Transfers
            if (Load_XMT_DR == 1'b1) XMT_datareg <= Data_reg;      // Get the data bus
            
            if (Load_XMT_shftreg == 1'b1)                          // Load shift reg, insert stop bit                   
                XMT_shftreg <= {XMT_datareg, 1'b1};

            if (start == 1'b1) XMT_shftreg[0] <= 0;                // Signal start of transmission

            if (clear == 1'b1) bit_count <= 0;
ß
            if (shift == 1'b1) begin
                XMT_shft_reg <= {1'b1, XMT_shftreg[word_size:1]};  // Shift right, fill with 1's
                bit_count <= bit_count + 1'b1;
            end
        end // Register_Transfers
    end         
endmodule

