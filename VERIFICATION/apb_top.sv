//`include "defines.svh"
`include "apb_package.sv"
`include "apb_interface.sv"
`include "apb_design.sv"
module apb_top();
	import apb_package::*;

	//declaring global variables that is clk and rst
	logic PCLK;
	logic PRESET_n;

		initial PCLK=0;
		always #10 PCLK=~PCLK;//toggling clk

  

	initial 
	begin
		//@(posedge PCLK);
		PRESET_n=0;
		//repeat(1) @(posedge PCLK);
		#10;
		PRESET_n=1;
	end
	apb_inf inf1(PCLK,PRESET_n);

	apb_test test = new(inf1.drv,inf1.mon);

	apb_slave #(.ADDR_WIDTH(`ADDR_WIDTH),.DATA_WIDTH(`DATA_WIDTH),.MEM_DEPTH(`DATA_DEPTH))dut(.PCLK(inf1.PCLK),.PRESETn(inf1.PRESET_n),.PADDR(inf1.PADDR),
	.PSEL(inf1.PSEL),.PENABLE(inf1.PENABLE),.PWRITE(inf1.PWRITE),.PWDATA(inf1.PWDATA),.PSTRB(inf1.PSTRB),.PRDATA(inf1.PRDATA),.PREADY(inf1.PREADY),.PSLVERR(inf1.PSLVERR));



	initial begin
//		wait(inf1.PRESET_n);//wait until rst is released
		$display("################################################## start of simulation #####################################################");
		test.run();
		$display("##################################################  end of simulation ######################################################");
		#1000;
		$finish;
	end
endmodule


	
