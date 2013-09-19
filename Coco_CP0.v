module Coco_CP0(
input[4:0] CP0Idx,
input[31:0] DIn,
input We,ExcEnter,
input[6:2] ExcCode,HWInt,
input Clk,Reset,
output[31:0]DOut,
output Inter,
output[31:0] EPCout
);
reg[31:0] SR,EPC,Cause,PRId;

assign DOut=(CP0Idx==5'd12)?SR:
            (CP0Idx==5'd13)?{Cause[31:16],1'b0,HWInt,3'b000,ExcCode,2'b00}:
            (CP0Idx==5'd14)?EPC:
            (CP0Idx==5'd15)?PRId:32'd0;

assign Inter=SR[0:0] &(| (SR[14:10] & HWInt));  

assign EPCout=EPC;

always @(posedge Clk or posedge Reset)
if (Reset)
 begin
     SR<=32'b0;
     Cause<=32'b0;
     EPC<=32'b0;
     PRId<={8'h47,8'h36,8'b0,8'h10};
 end
 else
    begin
     if (We)
    case (CP0Idx)
        5'd12:SR<=DIn;
        5'd13:Cause<=DIn;
        5'd14:EPC<=DIn;
        5'd15:PRId<=DIn;
    endcase    
   
    if (ExcEnter) 
     begin
         Cause[6:2]<=ExcCode;
         SR[0:0]<=0;
     end 
 end
     
endmodule
