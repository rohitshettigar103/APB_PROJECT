`define DATA_WIDTH 8
`define DATA_DEPTH 32
//`define ADDR_WIDTH 5
`define STRB_WIDTH (`DATA_WIDTH)/8
`define num_transaction 100

function int width(int n);
	begin
		automatic int width1 =0;
		while (n>1)
		begin
			n=n>>1;//divide by 2 ie 32/2->16/2....until n>0
			width1++;

		end
		return width1;
	end
endfunction

`define ADDR_WIDTH width(`DATA_DEPTH)




