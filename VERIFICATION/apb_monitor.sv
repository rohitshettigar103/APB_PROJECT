class apb_monitor;
    virtual apb_inf.mon vif;
    mailbox#(apb_transaction) mbx_mon_scb;
    apb_transaction tr;

    function new(mailbox#(apb_transaction) mbx_mon_scb, virtual apb_inf.mon vif);
        this.mbx_mon_scb = mbx_mon_scb;
        this.vif = vif;
    endfunction

    task start();
	    int count=0;
	$display("################################################## Monitor started #####################################################");

        //$display("[%0t] [Monitor] Starting", $time);
        while(count<`num_transaction)
	begin
		tr=new();
           
           @(vif.mon_cb);
           //$display("[%0t] Monitor PSEL=%b PENABLE=%b PADDR=%h", $time, vif.mon_cb.PSEL, vif.mon_cb.PENABLE, vif.mon_cb.PADDR); 
            // Check the condition manually
            if (vif.mon_cb.PSEL && vif.mon_cb.PENABLE/* && vif.mon_cb.PREADY*/) begin
                
		@(vif.mon_cb);
		  
                // Capture data
                tr.PADDR    = vif.mon_cb.PADDR;
                tr.PWRITE   = vif.mon_cb.PWRITE;
                tr.PWDATA   = vif.mon_cb.PWDATA;
                tr.PRDATA   = vif.mon_cb.PRDATA;
                tr.PSLVERR  = vif.mon_cb.PSLVERR;
                
                mbx_mon_scb.put(tr);
		    count++;
		   // @(vif.mon_cb);
                //$display("[%0t] [Monitor] Captured :PADDR %h, PRDATA: %h, PSLVERR: %b", 
                   //      $time, tr.PADDR, vif.mon_cb.PRDATA, tr.PSLVERR);
            end
        end
    endtask
endclass
