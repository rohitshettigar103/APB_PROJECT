//`include "apb_environment.sv"
class apb_test;
	apb_environment env_1;

	virtual apb_inf.drv drv_inf;
	virtual apb_inf.mon mon_inf;

	function new(virtual apb_inf.drv drv_inf,virtual apb_inf.mon mon_inf);
		this.drv_inf=drv_inf;
		this.mon_inf=mon_inf;
	endfunction

	task run();
		env_1=new(drv_inf,mon_inf);
		env_1.build();
		env_1.start();
	endtask
endclass
