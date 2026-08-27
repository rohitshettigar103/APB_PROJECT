class apb_driver;
	apb_transaction tr;

	mailbox#(apb_transaction) mbx_gen_drv;
	mailbox#(apb_transaction) mbx_drv_ref;

	virtual apb_inf vif;


	function new(mailbox#(apb_transaction)mbx_gen_drv,virtual apb_inf vif,mailbox#(apb_transaction) mbx_drv_ref);
		this.mbx_gen_drv=mbx_gen_drv;
		this.vif=vif;
		this.mbx_drv_ref=mbx_drv_ref;
	endfunction

	task start();
		//$display("################################################## started driver #####################################################");
		//$display("[%0t] started to drive values ",$time);
		wait(vif.PRESET_n);//wait until reset is deasserted
		@(vif.drv_cb);
		repeat(`num_transaction)//that many no times we should ge the generated values
		begin
			//tr=new();
			mbx_gen_drv.get(tr);//getting generated values from generator via mailbox
			apb_drive(tr);
		end
		//$display("[%0t][driver] simulation done",$time);
		//$display("################################################## end of driver #####################################################");
	endtask

	task apb_drive(apb_transaction tr);
		if(!vif.PRESET_n)
			begin
				//$display("Reset asserted:means in a idle state");
				vif.drv_cb.PSEL<=0;
				vif.drv_cb.PENABLE<=0;
				vif.drv_cb.PADDR<=0;
				vif.drv_cb.PWRITE<=0;
				vif.drv_cb.PWDATA<=0;
				@(vif.drv_cb);//wait for once cycle and check whether reset is asserted or not
			end
		else
		begin
			//$display("[%0t][Driver] Driving Transaction: Addr=%h, Data=%h, Write=%b",$time, tr.PADDR, tr.PWDATA, tr.PWRITE);
			//normal operation
			@(vif.drv_cb);//setup
			vif.drv_cb.PSEL<=1;
			vif.drv_cb.PENABLE<=0;
			vif.drv_cb.PADDR<=tr.PADDR;
			vif.drv_cb.PWDATA<=tr.PWDATA;
			vif.drv_cb.PWRITE<=tr.PWRITE;
			vif.drv_cb.PSTRB<=tr.PSTRB;

			//$display("[%0t][Driver] Driving Transaction(:::::::setup state::::::): Addr=%h, Data=%h, Write=%b,Psel=%b,Penable=%b",$time, tr.PADDR, tr.PWDATA, tr.PWRITE,vif.drv_cb.PSEL,vif.drv_cb.PENABLE);

			@(vif.drv_cb);//acess
			vif.drv_cb.PENABLE<=1;
			//$display("[%0t][Driver] Driving Transaction(:::::::access state::::::): Addr=%h, Data=%h, Write=%b,Psel=%b,Penable=%b",$time, tr.PADDR, tr.PWDATA, tr.PWRITE,vif.drv_cb.PSEL,vif.drv_cb.PENABLE);
			mbx_drv_ref.put(tr);
			@(vif.drv_cb);//idle
			vif.drv_cb.PSEL<=0;
			vif.drv_cb.PENABLE<=0;
			//$display("[%0t][Driver] Driving Transaction(:::::::idle state::::::): Addr=%h, Data=%h, Write=%b,Psel=%b,Penable=%b",$time, tr.PADDR, tr.PWDATA, tr.PWRITE,vif.drv_cb.PSEL,vif.drv_cb.PENABLE);
		end
	endtask
endclass

			

			



			




			
