`timescale 1ns/1ps
module tb();
  reg input_stream,clock;
  wire [7:0]output_stream;
// Clock periiod = 1/frequency = 40ns
// Bit period = number of clocks per bit times clock period
  parameter clock_period=40;
  parameter bit_period=104200;
  integer i;
  uart i1(input_stream,clock,output_stream);
  
  always #(clock_period/2) clock=~clock;
// Task that throws input to the design.  
  task check;
    input [7:0]in;
    begin
      input_stream=1'b0;
      #(bit_period);
    	for(i=0;i<8;i=i+1) begin
      		input_stream=in[i];
      		#(bit_period);
    	end
      input_stream=1'b1;
    end
  endtask
  
  initial begin
    clock=0;
    $dumpfile("tb.vcd");
    $dumpvars;
    $display("Sent byte --- 10010011");
    $monitor("Received byte --- %b",output_stream);
    check(8'b10010011);
    #(bit_period);
    if(output_stream==8'b10010011) begin
      $display("Correct sequence received.");
      $display("Receiving frequency --- %f MHz",25.0);
      $display("Sending frequency --- %f Mhz",2605000.0/bit_period);
    end
    else begin
      $display("Incorrect sequence received.");
      $display("Receiving frequency --- %f MHz",25.0);
      $display("Sending frequency --- %f Mhz",260500.0/bit_period);
    end
    $finish;
  end
endmodule
