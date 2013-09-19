module Coco_Shift(
input[31:0] Din,
input[4:0] Num,
input[1:0] LorR,
output[31:0] Dout);
wire[31:0] lr,ar,ll;
assign ll=Din << Num;
assign lr=Din >> Num;
assign ar=(Din[31])?~((~Din) >> Num):Din >> Num;
assign Dout=(LorR[1])?ll: (LorR[0])?lr:ar ;
endmodule
