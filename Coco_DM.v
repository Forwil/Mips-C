module Coco_DM(
input Clk,Reset,
input[14:2] A,
input[31:0]Din,
input[3:0]BE,
input We,
output[31:0] Dout);

parameter N=13;
reg[31:0] DM[1<<N -1:0];
integer i;

assign Dout=DM[A];

always @(posedge Clk,posedge Reset)
if (Reset)
   for(i=0;i<1<<N;i=i+1)
    DM[i]<=32'h0000_0000;
 else
    if (We)
        begin
        if (BE[0]) DM[A][7:0]<=Din[7:0];
        if (BE[1]) DM[A][15:8]<=Din[15:8];
        if (BE[2]) DM[A][23:16]<=Din[23:16];
        if (BE[3]) DM[A][31:24]<=Din[31:24];
        end     
endmodule