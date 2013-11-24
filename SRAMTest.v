module SRAMTest(
	input [17:0]SW,
	inout [15:0] SRAM_DQ,   // SRAM Data bus 16 Bits
   output [17:0] SRAM_ADDR, // SRAM Address bus 18 Bits
   output SRAM_UB_N,        // SRAM High-byte Data Mask
   output SRAM_LB_N,        // SRAM Low-byte Data Mask 
   output reg SRAM_WE_N,    // SRAM Write Enable
   output SRAM_CE_N,        // SRAM Chip Enable
   output SRAM_OE_N,        // SRAM Output Enable
	output [17:0]  LEDR,  //  LED Red[17:0]
	input CLOCK_50,
	input [3:0]KEY
	);
	
	reg firstTime;
	reg [7:0]mem_addr;
	reg write;
	reg [7:0]mem_in;
	reg [15:0]mem_out;
	reg [17:0]lights;
	wire [2:0]counter;
	
   assign SRAM_UB_N = 1'b0;        // SRAM High-byte Data Mask
   assign SRAM_LB_N = 1'b0;        // SRAM Low-byte Data Mask 
   assign SRAM_CE_N = 1'b0;        // SRAM Chip Enable
   assign SRAM_OE_N = 1'b1;        // SRAM Output Enable
	
	always @(posedge CLOCK_50)
	begin
		mem_in <= SW[7:0];
		SRAM_WE_N <= ~KEY[3];
	end
	always @(negedge KEY[1])
    mem_addr <= SW[17:10];
assign SRAM_DQ = (SRAM_WE_N? {8'd0,mem_in} : SRAM_DQ);
assign LEDR = (~KEY[2]? {2'd0,SRAM_DQ}:18'd0);
assign SRAM_ADDR = {10'd0,mem_addr};
endmodule

module counter(
input clk,
input rst,
output reg [2:0]counter
);

reg [25:0]clk_count;

always @(posedge clk or negedge rst)
begin
	if(rst==1'b0)
	begin
			counter <= 3'd0;
			clk_count<= 26'd0;
	end
	else
	begin
		if(clk_count==26'd49999999 && counter == 3'd5)
		begin
			counter <= 3'd0;
			clk_count <= 26'd0;
		end
		else if(clk_count==26'd49999999)
		begin
			counter <= counter+1;
			clk_count <= 26'd0;
		end
		else
			clk_count=clk_count+1'b1;
	end
end
endmodule
