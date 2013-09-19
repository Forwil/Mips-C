module Coco_MulDiv(
input Clk,Reset,
input[31:0] Ain,Bin,
input Start,MorD,HorL,Sign,We,
output Ready,
output[31:0] DC
);

reg[63:0] HILO;
reg[5:0]  count;
wire[31:0] DA,DB;
wire[63:0] BB;

assign DA=(Sign && Ain[31])? (~Ain)+1:Ain;
assign DB=(Sign && Bin[31])? (~Bin)+1:Bin;

assign DC=(HorL)?HILO[63:32]:HILO[31:0];

assign Ready=(Start && ((count==6'b100000 && MorD)||(count==6'b100010 && ~MorD)));

assign BB=(MorD)?{{32{1'b0}},DB}: {DB,{32{1'b0}}};

always @(posedge Clk,posedge Reset)
if (Reset)
 begin
     count<=6'b0;
     HILO <=64'b0; 
 end
else
if (~Start)
 begin
     if (We) HILO<=(HorL)?{Ain,HILO[31:0]}:{HILO[63:32],Ain};
      else count<=6'b0; 
 end
else
if (Start && MorD)
 begin
   if (DA[count])  
    HILO<=(Sign && (Ain[31] ^ Bin[31]) && count==6'b011111)?~(HILO+(BB << count))+1:HILO+(BB << count);
    count<=count+1;
 end 
else

if (Start && ~MorD)
 begin
   if (count==6'b0) HILO[63:32]<=DA;
   else  
   if ((BB >> count)< HILO[63:32] && count!=6'b100001)  
    begin
     HILO[63:32]<= HILO[63:32]-(BB >> count);
     HILO[32-count]<=1'b1;
    end 
   else
    if (count==6'b100001) 
     begin
     HILO[63:32]<=(Sign && Ain[31])? ~HILO[63:32]+1 :HILO[63:32];
     HILO[31:0] <=(Sign && (Ain[31] ^ Bin[31]))? ~HILO[31:0]+1:HILO[31:0];
     end
   count<=count+1;  
 end 
 
endmodule
