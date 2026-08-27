//`include "defines.svh"
//`include "apb_transaction.sv"
class apb_generator;

	//declaring transaction class handle
	apb_transaction tr;
	//creating a mailbox for generator to driver
	mailbox#(apb_transaction)mbx_gen_drv;

	function new(mailbox#(apb_transaction)mbx_gen_drv);
		this.mbx_gen_drv=mbx_gen_drv;
		tr=new();
	endfunction

	//task to generate random values
	task start();
		$display("################################################## start generation #####################################################");
		repeat(`num_transaction)
		begin
			if(tr.randomize())
			$display("Generated values:::::PWDATA:%h,PADDR:%h,PWRITE:%b,pstrb:%h",tr.PWDATA,/*tr.PSEL,tr.PENABLE,*/tr.PADDR,
				tr.PWRITE,tr.PSTRB);
			mbx_gen_drv.put(tr.copy());
		end
	endtask
endclass


