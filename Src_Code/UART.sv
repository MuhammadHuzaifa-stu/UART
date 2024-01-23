module UART (
	input  logic       clk, 
	input  logic       load_byte, 
	input  logic       t_byte, 
	input  logic       rst, 
	input  logic [7:0] data, 
	
	output logic       serial_out
);
	
	//FSM parameters
	logic c1; 
	logic c2; 
	logic load_xmt_shift; 
	logic load_xmt_dreg;
	logic shift; 
	logic out; 
	logic clear_baud; 
	logic start; 
	logic clear; 
	logic en;
	
	//counter + comparater parameters
	logic [3:0] counter_up2; 
	logic [2:0] counter_up;
	
	//FSM
	FSM F1 (
		.byte_ready  (load_byte     ),
		.clk         (clk           ),
		.t_byte      (t_byte        ),
		.counter_baud(c1            ),
		.counter_of  (c2            ),
		.rst         (rst           ), 
		.en          (en            ),
		.shift       (shift         ),
		.load_xmt    (load_xmt_dreg ),
		.load_xmt_2  (load_xmt_shift),
		.clear_baud  (clear_baud    ),
		.start       (start         ),
		.clear       (clear         )
	);
		
	//Shift register
	Shift_reg S1 (
		.Clk        (clk		   ),
		.load       (load_xmt_shift),
		.shift_i    (shift         ),
		.rst        (rst           ),
		.Parallel_In(data          ),
		.Serial_Out (out           )
	);
	
	//Mux
	mux2x1 m1 (
		.a(1'b1      ),
		.b(out       ),
		.s(start     ), 
		.c(serial_out)
	);
	
	//Baud Counter plus comparater
	//up counter
	baudcounter count1 (
		.clk       (clk       ), 
		.clear_baud(clear_baud), 
		.c1        (c1        )
	);
	
	//Bit Counter plus comparater
	//up counter
	bitcounter count2 (
		.clk  (clk  ), 
		.clear(clear), 
		.en   (en   ), 
		.c2   (c2   )
	);
	
endmodule: UART