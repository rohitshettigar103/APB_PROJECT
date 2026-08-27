
//`include "defines.svh"
class apb_transaction;

	//declaring inputs for randomization
	rand bit [`DATA_WIDTH-1:0]PWDATA;
	 bit PSEL;
	 bit PENABLE;
	rand bit PWRITE;
	rand bit [`ADDR_WIDTH-1:0] PADDR;
	rand bit [`STRB_WIDTH-1:0] PSTRB;
	//declaring outputs
	bit [`DATA_WIDTH-1:0] PRDATA;
	bit PREADY;
	bit PSLVERR;

	constraint addr_align{
		PADDR%4==0;//for a perfect allignment of address so that it occurs in a multiple of 4
	}
	constraint pwrite_dist{
		PWRITE dist{
			0:=50,//equal occurance of read and write so tht i can check errors
			1:=50
		};
	}
	constraint pstrb_err{
		PSTRB!=0;//it should not be zero in the case of 32 bit atleast 1 byte ahould be high
	}


	function apb_transaction copy();
		copy=new();
		copy.PWDATA=this.PWDATA;
//		copy.PSEL=this.PSEL;
//		copy.PENABLE=this.PENABLE;
		copy.PWRITE=this.PWRITE;
		copy.PADDR=this.PADDR;
		copy.PSTRB=this.PSTRB;
		return copy;
	endfunction

endclass

	
