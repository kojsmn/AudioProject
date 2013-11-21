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
	output reg [15:0]a[1999:0],
	input rst
);



//	16 Bits - MSB First
// Clocks in the ADC input
// and sets up the output bit selector

reg [9:0] SEL_reg;
reg [3:0] SEL_Bit;
reg [3:0] SEL_Cont;
always@(negedge AUD_BCK or negedge iRST_N)
begin
	if(!iRST_N)
	begin
	   SEL_Cont <= 4'h0;
		SEL_reg <= 10'd0;
		SEL_Bit <= 4'd0;
	end
	else 
		begin
	   if(SEL_Bit==4'd15 && SEL_reg != 10'd1999)
		SEL_reg <= SEL_reg+1'b1;
	   SEL_Bit <= SEL_Bit+1'b1;
	   SEL_Cont <= SEL_Cont+1'b1; //4 bit counter, so it wraps at 16
	   if (AUD_LRCK && SEL_reg < 10'd1999)
		begin
		  AUD_inL[~(SEL_Cont)] <= AUD_ADCDAT;
	     a[SEL_reg][SEL_Bit] <= AUD_DATA;
		
		
		end
	   else if(SEL_reg < 10'd2000)
		begin
		  AUD_inR[~(SEL_Cont)] <= AUD_ADCDAT;
		  a[SEL_reg][SEL_Bit] <= AUD_DATA;
	//	  a[SEL_reg][SEL_Bit] <= AUD_ADCDAT;
		
		end
	end
end


always @ (*)
begin
	// output the DAC bit-stream
	case (SW)
			1'b0 : AUD_DATA = (AUD_LRCK)? AUD_outL[~SEL_Cont]: AUD_outR[~SEL_Cont] ;
			default: 
				begin
				AUD_DATA = a[SEL_reg][SEL_Bit];
				//AUD_DATA = 1'b1;
				end
	endcase
end



endmodule