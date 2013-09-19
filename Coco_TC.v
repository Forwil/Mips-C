module Coco_TC(
input Clk,Reset,
input[1:0] Add,
input We,
input[31:0] Data_In,
output[31:0] Data_Out,
output Out
);
reg[31:0] TC[2:0];
wire[31:0] kan;
assign kan=TC[2];

assign Out=(TC[2]==32'b0 && (TC[0][2:1]==2'b01 || TC[0][2:1]==2'b00))||
              ((TC[2]>(TC[1]>>1))&&(TC[0][2:1]==2'b10));
              

assign Data_Out=TC[Add];

always @(posedge Clk or posedge Reset)
if (Reset)
 begin
    TC[0]<=32'h0000_0000;
    TC[1]<=32'h0000_0000;
    TC[2]<=32'h0000_0001;
 end
else
if (We)
 begin
     if (Add==4'd1)
        begin
        TC[2]<=Data_In-1;
        TC[1]<=Data_In-1;
        end
     else
     TC[Add]<=Data_In;
 end
 else
  begin
    if (TC[2]==32'b0 && TC[0][2:1]!=2'b00) TC[2]<=TC[1];     
    if (TC[0][0] && TC[2]!=32'b0) TC[2]<=TC[2]-32'b1;
  end
endmodule
