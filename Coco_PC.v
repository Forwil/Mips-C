module Coco_PC(Clk,Reset,NextPC,PCWr,PC);
input Clk,Reset,PCWr;
input[31:0] NextPC;
output[31:0] PC;
reg[31:0] PC;
always @(posedge Clk or posedge Reset)
   begin
   if (Reset) PC<=32'hBFC00000; 
   else
    if (PCWr) PC<=NextPC;  
   end
   
 endmodule