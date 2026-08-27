class apb_scoreboard;
    
    apb_transaction ref_scr_tr;
    apb_transaction mon_scr_tr;
    mailbox #(apb_transaction) mbx_ref_scr;
    mailbox #(apb_transaction) mbx_mon_scr;

    logic [`DATA_WIDTH-1:0] ref_mem [`DATA_DEPTH-1:0];
    logic [`DATA_WIDTH-1:0] mon_mem [`DATA_DEPTH-1:0];
    
    int match = 0;
    int mismatch = 0;

    function new(mailbox #(apb_transaction) mbx_mon_scr, mailbox #(apb_transaction) mbx_ref_scr);
        this.mbx_ref_scr = mbx_ref_scr;
        this.mbx_mon_scr = mbx_mon_scr;
    endfunction

    task start();
        $display("[%0t] [SCOREBOARD] starting comparision", $time);
        for(int i=0; i<`num_transaction; i++) begin
        fork   
                begin
                    mbx_ref_scr.get(ref_scr_tr);
                /*    if (!ref_scr_tr.PWRITE) begin
                        ref_mem[ref_scr_tr.PADDR] = ref_scr_tr.PRDATA;
                    end else begin
                        ref_mem[ref_scr_tr.PADDR] = ref_scr_tr.PWDATA;
                    end
                    $display("###############################[REFERENCE to SCOREBOARD],time:%0t,data_out=%0h | address=%h #####################", $time,				ref_mem[ref_scr_tr.PADDR], ref_scr_tr.PADDR);*/
                end 
                
                begin
                    mbx_mon_scr.get(mon_scr_tr);
                /*    if (!mon_scr_tr.PWRITE) begin
                        mon_mem[mon_scr_tr.PADDR] = mon_scr_tr.PRDATA;
                    end else begin
                        mon_mem[mon_scr_tr.PADDR] = mon_scr_tr.PWDATA;
                    end
                    $display("##################################[MONITOR TO SCOREBOARD],w=%d,r=%d,time:%0t,data_out=%0h | address=%h####################",			mon_scr_tr.PWRITE, !mon_scr_tr.PWRITE, $time, mon_mem[mon_scr_tr.PADDR], mon_scr_tr.PADDR);*/
                end
		
	join
            compare_report();

        end
       	print_summary();
    endtask

    task compare_report();
        //if (ref_mem[ref_scr_tr.PADDR] === mon_mem[mon_scr_tr.PADDR]) 
	    if(ref_scr_tr.PRDATA === mon_scr_tr.PRDATA)
	    begin
            $display("PASS: [SCOREBOARD] %0t REF data_out=%0h | MON_data_out=%0h", $time, ref_scr_tr.PRDATA, mon_scr_tr.PRDATA);
            ++match;
            $display("[MATCH] count = %0d", match);
        end 
        else begin
            $display("FAIL: [SCOREBOARD] %0t REF data_out=%0h | MON_data_out=%0h", $time, ref_scr_tr.PRDATA, mon_scr_tr.PRDATA);
            ++mismatch;
            $display("[MISMATCH] count = %0d", mismatch);
        end
    endtask

   function void print_summary();
        $display("\n========================================================");
        $display("             FINAL SIMULATION RUN SUMMARY               ");
        $display("========================================================");
        $display("  Total Matches Checked   : %0d", match);
        $display("  Total Mismatches Found  : %0d", mismatch);
        $display("  Verification Verdict    : %s", (mismatch == 0) ? "PASSED" : "FAILED");
        $display("========================================================\n");
    endfunction
endclass

