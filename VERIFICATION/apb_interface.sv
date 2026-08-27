`include"defines.svh" 
interface apb_inf(input bit PCLK,input bit PRESET_n); 

//declaring inputs 
logic [`ADDR_WIDTH-1:0]PADDR; 
logic PSEL; 
logic PENABLE; 
logic PWRITE; 
logic [`DATA_WIDTH-1:0] PWDATA; 
logic [`STRB_WIDTH-1:0] PSTRB; 

//output declaration 
logic [`DATA_WIDTH-1:0] PRDATA; 
logic PREADY; 
logic PSLVERR; 

clocking drv_cb @(posedge PCLK); 
  default input #1 output #1; 
  output PADDR,PSEL,PENABLE,PWRITE,PWDATA,PSTRB,PRESET_n; 
  input PREADY,PRDATA; 
endclocking 

clocking mon_cb @(posedge PCLK); 
  default input #1; 
	input PADDR,PSEL,PENABLE,PWRITE,PWDATA,PSTRB, PREADY,PSLVERR,PRDATA,PRESET_n; 
endclocking 

//creating modports for driver,monitor and dut so that it can be accesed easily 
modport drv(clocking drv_cb ,input PADDR,PSEL,PENABLE,PWRITE,PWDATA,PSTRB, PREADY,PSLVERR,PRDATA,PRESET_n); 
modport mon(clocking mon_cb); 
//modport slave_dut(input PADDR,PSEL,PENABLE,PWRITE,PWDATA,PSTRB,PCLK,PRSTn, 
//                  output PREADY,PRDATA,PSLVERR); 

endinterface

