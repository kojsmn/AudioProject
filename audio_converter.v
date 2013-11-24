module audio_converter (
	// Audio side
	input AUD_BCK,    // Audio bit clock
	input AUD_LRCK,   // left-right clock
	input AUD_ADCDAT,
	output reg AUD_DATA,
	// Controller side
	input iRST_N,  // reset
	input [15:0] AUD_outL,
	input [15:0] AUD_outR,
	output reg[15:0] AUD_inL,
	output reg[15:0] AUD_inR,
	input SW,
	output reg [15:0]SRAM_DQ,
	output reg [17:0]SRAM_ADDR,
	output reg SRAM_WE_N,
	output reg SRAM_UB_N,
	output reg SRAM_LB_N,
	output reg SRAM_CE_N,
	output reg SRAM_OE_N,
	input rst
);



//	16 Bits - MSB First
// Clocks in the ADC input
// and sets up the output bit selector

reg [3:0] SEL_Cont;
reg [17:0] SEL_Add;

assign SRAM_UB_N = 1'b0;        // SRAM High-byte Data Mask
assign SRAM_LB_N = 1'b0;        // SRAM Low-byte Data Mask 
assign SRAM_CE_N = 1'b0;        // SRAM Chip Enable
assign SRAM_OE_N = 1'b0;        // SRAM Output Enable

always@(negedge AUD_BCK or negedge iRST_N or negedge rst)
begin
	if(!iRST_N || !rst)
	begin
	   SEL_Cont <= 4'h0;
		SEL_Add <= 18'd0;
	end
	else 
		begin
	   SEL_Cont <= SEL_Cont+1'b1; //4 bit counter, so it wraps at 16
		if(SEL_Cont==4'd15)
		  SEL_Add=SEL_Add+1'b1;
	   if (AUD_LRCK)
		begin
		  AUD_inL[~(SEL_Cont)] <= AUD_ADCDAT;
		  if(!SW)
		    SRAM_DQ[~SEL_Cont] <= AUD_ADCDAT;
		end
	   else
		begin
		  AUD_inR[~(SEL_Cont)] <= AUD_ADCDAT;
		  if(!SW)
		    SRAM_DQ[~SEL_Cont] <= AUD_ADCDAT;
		end
	end
end


always @ (*)
begin
	// output the DAC bit-stream
	SRAM_ADDR=SEL_Add;
	
	case (SW)
			1'b0 : begin
			  AUD_DATA = (AUD_LRCK)? AUD_outL[~SEL_Cont]: AUD_outR[~SEL_Cont] ;
			  SRAM_WE_N=1'b1;
			end
			default: 
			begin
			  AUD_DATA = SRAM_DQ[~SEL_Cont];
			  SRAM_WE_N=1'b0;
			end
	endcase
end



endmodule