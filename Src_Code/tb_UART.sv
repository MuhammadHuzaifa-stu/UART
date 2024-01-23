`timescale 1ps/1ps
module tb_UART;
	
	logic       clk; 
	logic       load_byte; 
	logic       t_byte; 
	logic       rst; 
	logic       serial_out;
	
	logic [7:0] data;
	
	UART DUT (
		.clk       (clk       ), 
		.load_byte (load_byte ), 
		.t_byte    (t_byte    ), 
		.rst       (rst       ),
		.data      (data      ),
		.serial_out(serial_out)
	);

	initial 
	begin
		clk = 0;
		forever #3 clk = ~clk;
	end
	
	//all initial blocks run parallel wise
	initial 
	begin
		rst = 1;
	
		@(posedge clk);
		rst       = 0;
		data      = 8'b01010101;
		load_byte = 0;
		t_byte    = 0;
		
		//repeat(10) @(posedge Clk);//simple @(posedge clk) for 1 clk
		
		@(posedge clk);
		load_byte = 1;
		
		@(posedge clk);
		load_byte = 0;
		
		@(posedge clk);
		t_byte = 1;
		
		@(posedge clk);
		t_byte = 0;
		
		@(posedge clk);
		
		repeat(60)@(posedge clk);
		
		@(posedge clk);
		rst = 1;
		
		@(posedge clk);
		rst       = 0;
		data      = 8'b00101010;
		load_byte = 0;
		t_byte    = 0;
		
		//repeat(10) @(posedge Clk);//simple @(posedge clk) for 1 clk
		
		@(posedge clk);
		load_byte = 1;
		
		@(posedge clk);
		load_byte = 0;
		
		@(posedge clk);
		t_byte = 1;
		
		@(posedge clk);
		t_byte = 0;
		
		@(posedge clk);
		
		repeat(60)@(posedge clk);
		
		@(posedge clk);
		rst = 1;
		
		@(posedge clk);
		rst = 0;
		
		@(posedge clk);
		
		$stop;
	
	end

endmodule: tb_UART
