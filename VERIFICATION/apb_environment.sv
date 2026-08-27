class apb_environment;
	//declaring virtual interface for driver and monitor so that i can pass it to driver and monitor
	virtual apb_inf.drv drv_vif;//declaring drv_vif is a modport of type apb_inf
	virtual apb_inf.mon mon_vif;

	//declaring all the mailboxes used
	mailbox#(apb_transaction) mbx_gen_drv;
	mailbox#(apb_transaction) mbx_mon_scr;
	mailbox#(apb_transaction) mbx_drv_ref;
	mailbox#(apb_transaction) mbx_ref_scr;

	//declaring of all class handles
	apb_generator gen;
	apb_driver drv;
	apb_monitor mon;
	apb_scoreboard scr;
	apb_reference reff;

	function new(virtual apb_inf.drv drv_vif,virtual apb_inf.mon mon_vif);
		this.drv_vif=drv_vif;
		this.mon_vif=mon_vif;
	//	this.mbx_gen_drv=mbx_gen_drv;
	//	this.mbx_mon_scr=mbx_mon_scr;
	endfunction

	//creating mailbox and object for the handles
	
	task build();
		begin
		//creating mailbox
		mbx_gen_drv=new;
		mbx_mon_scr=new;
		mbx_drv_ref=new;
		mbx_ref_scr=new;

		//creating objects for handle
		gen=new(mbx_gen_drv);
		drv=new( mbx_gen_drv,drv_vif,mbx_drv_ref);
		mon=new(mbx_mon_scr,mon_vif);
		scr=new(mbx_mon_scr,mbx_ref_scr);
		reff=new(mbx_drv_ref,mbx_ref_scr,mon_vif);

		end
	endtask

	task start();
		fork
			gen.start();
			drv.start();
			mon.start();
			reff.start();
			scr.start();
		join

//		repeat(10)@(drv_vif.drv_cb);
	endtask
endclass




