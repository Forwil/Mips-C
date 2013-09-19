`include "Coco_SystemBridge.v"
`include "Coco_IM.v"
`include "Coco_DM.v"
`include "Coco_MIPSC.v"
`include "Coco_TC.v"
module Coco_MyProject(
input Clk,Reset);

wire[31:2] PrA;    
wire[3:0] PrBE;
wire[31:0] Din_LED,DOut_LED,PrWData,PrRData,DOut_IM,DOut_DM,Din_DM,Din_TC,DOut_TC;    
wire PrReq,PrRW,PrReady,We_DM,We_LED,We_TC,Out;
wire[10:0] A_IM;
wire[12:0] A_DM;   
wire[3:0] BE;   
wire[1:0] A_TC;

Coco_IM IM(A_IM,DOut_IM);
Coco_DM DM(Clk,Reset,A_DM,Din_DM,BE,We_DM,DOut_DM);

Coco_SystemBridge SB(
Clk,PrA,PrBE,PrWData,PrRData,PrReq,PrRW,PrReady,
A_IM,DOut_IM,
A_DM,Din_DM,BE,We_DM,DOut_DM,
A_TC, Din_TC, We_TC,DOut_TC,
Din_LED,We_LED,DOut_LED
);
Coco_TC TC(Clk,Reset,A_TC,We_TC,Din_TC,DOut_TC,Out);
Register LED(Clk,Reset,Din_LED,We_LED,DOut_LED);
Coco_MIPSC MIPSC(Clk,Reset,PrA,PrBE,PrWData,PrRData,PrReq,PrRW,PrReady,{4'b0,Out});
endmodule
