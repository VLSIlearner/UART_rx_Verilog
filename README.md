# UART_rx_Verilog

UART is an asynchronous design. This project involves designing of UART receiver in Verilog HDL in FSM architecture. Let the frequency of the clock be 25MHz I am considering the baudrate to be 9600 From the above, number of clocks in a bit can be calculated as 25000000/9600 = 2605 Input stream is an 8 bit data Start bit - 0 Stop bit - 1 Each bit is accessed in the middle of its level rather than on the edge to avoid errors.
