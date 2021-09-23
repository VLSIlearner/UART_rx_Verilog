// Let the frequency of the clock be 25MHz
// I am considering the baudrate to be 9600
// From the above, number of clocks in a bit can be calculated as 25000000/9600 = 2605
// Input stream is an 8 bit data
// Start bit - 0
// Stop bit - 1
// Each bit is accessed in the middle of its level rather than on the edge to avoid errors..

`timescale 1ns/1ps
module uart(input_stream,clock,output_stream);
  input input_stream,clock;
  output reg [7:0]output_stream;
  integer count;
  integer clocks_per_bit=0;
  
  //Declaring states of the machine:
  // Idle: Machine remains idle till it sees a zero in the input stream.
  // Start: When the machine reaches the middle of start bit, machine goes into receiving state.
  // Receive: After receiving 8 bits, if the machine sees a 1 in the input stream, it goes into stop state.
  // Stop: Machine waits for a bitperiod and goes into idle state.
  localparam idle=0, start=1, receive=2, stop=3;
  reg [1:0] machine;
  
  always@(posedge clock) begin
    case(machine)
      idle: begin
        if(input_stream==0) machine<=start;
        else machine<=idle;
      end
      start: begin
        if(clocks_per_bit<(2605/2)) begin
          clocks_per_bit=clocks_per_bit+1;
          machine<=start;
        end
        else begin
          clocks_per_bit=0;
          machine<=receive;
        end
      end
      receive: begin
        if(count<8) begin
          if(clocks_per_bit<2605) begin
          	clocks_per_bit=clocks_per_bit+1;
            machine<=receive;
          end
          else begin
            output_stream[count]<=input_stream;
          	count=count+1;
            clocks_per_bit=0;
            machine<=receive;
          end
        end
        else begin
          count=0;
          clocks_per_bit=0;
          if(input_stream==1'b1) begin
          machine<=stop;
          end
          else begin
          	machine<=idle;
          end
        end
      end
      stop: begin
        if(clocks_per_bit<2605) begin
		  clocks_per_bit=clocks_per_bit+1;
          machine<=stop;
        end
        else begin
          machine<=idle;
        end
      end
      default: begin
        output_stream=8'b00000000;
        machine<=idle;
        count=0;
        clocks_per_bit=0;
      end
    endcase
  end
endmodule
