module top();
	apb_environment env_1;

	import apb_package::*;

	logic pclk;
	logic prstn;

	initial pclk=0;
	begin
		forever #10 pclk=~pclk;
	end

	begin
		@(posedge clk);
		prstn=0;
		repeat(4)

