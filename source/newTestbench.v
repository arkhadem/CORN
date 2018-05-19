`timescale 1ps / 1fs

module newTestbench;

	// Inputs
	reg Clk = 1;
	reg Rst = 0;
	reg En = 0;
	reg InputReady = 0;
	reg [15:0] Inputs;

	// Outputs
	wire Done;
	wire [15:0] Q [7:0];

	// Instantiate the Unit Under Test (UUT)
	CORNDesign uut (
		.Clk(Clk),
		.Rst(Rst),
		.En(En),
		.InputReady(InputReady),
		.Inputs(Inputs),
		.Done(Done),
		.Q1(Q[0]),
		.Q2(Q[1]),
		.Q3(Q[2]),
		.Q4(Q[3]),
		.Q5(Q[4]),
		.Q6(Q[5]),
		.Q7(Q[6]),
		.Q8(Q[7])
	);

	always
		#57 Clk = ~Clk;

	initial begin
	#28;
	Rst = 1'b1;
	#114;
	Rst = 1'b0;
	#114;
	En = 1'b1;
	#114;
	InputReady = 1'b1;
	#114;
	InputReady = 1'b0;
	Inputs = 16'b0000000010101000;
	#114;
	Inputs = 16'b0000000011010111;
	#114;
	Inputs = 16'b0000000010010001;
	#114;
	Inputs = 16'b0000000000100101;
	#114;
	Inputs = 16'b0000000011100111;
	#114;
	Inputs = 16'b0000000001100111;
	#114;
	Inputs = 16'b0000000001010101;
	#114;
	Inputs = 16'b0000000000100101;
	#114;
	Inputs = 16'b0000000001010000;
	#114;
	Inputs = 16'b0000000011100110;
	#114;
	Inputs = 16'b0000000010110010;
	#114;
	Inputs = 16'b0000000010100110;
	#114;
	Inputs = 16'b0000000001000000;
	#114;
	Inputs = 16'b0000000011000011;
	#114;
	Inputs = 16'b0000000000010110;
	#114;
	Inputs = 16'b0000000001011110;
	@(negedge Done)
	$finish;
	end

endmodule
