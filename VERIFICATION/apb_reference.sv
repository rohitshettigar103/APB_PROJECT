class apb_reference;
    apb_transaction trans_ref;
    
    mailbox#(apb_transaction) mbx_drv;
    mailbox#(apb_transaction) mbx_ref_scr;
    
    // Virtual interface 
    virtual apb_inf.mon vif; 
    
    // memory to store data while write operation and extract while read operation
    reg [`DATA_WIDTH-1:0] mem_ref[`DATA_DEPTH-1:0];

    function new(mailbox#(apb_transaction) mbx_drv, mailbox#(apb_transaction) mbx_ref_scr, virtual apb_inf.mon vif);
        this.mbx_drv= mbx_drv;
        this.mbx_ref_scr = mbx_ref_scr;
        this.vif = vif;
    endfunction

    task start();
        repeat(`num_transaction) begin
            trans_ref = new();
            mbx_drv.get(trans_ref);

            // Checking active-low reset 
            if (vif.mon_cb.PRESET_n == 0) begin
                foreach(mem_ref[i]) begin
                    mem_ref[i] = 0;
                end
                trans_ref.PRDATA = '0; 
            end 
            else begin
                // Synchronise with clock 
                @(vif.mon_cb);
                
                if (trans_ref.PWRITE) begin
                    // APB Write Operation
                    mem_ref[trans_ref.PADDR] = trans_ref.PWDATA;
                    trans_ref.PRDATA = '0; // Clear read data field during writes
                    $display("Reference: data into memory mem[%h]=%h", trans_ref.PADDR, trans_ref.PWDATA);
                end 
                else begin
                    // APB Read Operation
                    trans_ref.PRDATA = mem_ref[trans_ref.PADDR];
                    $display("Reference: data out at addr:%h, PRDATA:%h", trans_ref.PADDR, trans_ref.PRDATA);
                end
            end
            
            // Push reference item forward to scoreboard
            mbx_ref_scr.put(trans_ref);
        end
    endtask
endclass

