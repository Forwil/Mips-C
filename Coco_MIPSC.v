`include "Coco_Define.v"
`include "Coco_DataPath.v"
`include "Coco_Controler.v"
module Coco_MIPSC(
input Clk,Reset,
output[31:2] A,
output[3:0] BE,
output[31:0] WData,
input[31:0] RData,
output Req,RW,
input Ready,

input[6:2] HWInt
);
wire[0:0] M7_CP0Index, M9_CP0Data,CP0Write,PrExcEnter,Inter,Compare,PCEn,MemWe,M3_ALUsrcA,M5_Shift,M10_Addr,RegWe,IRWrite,EasyExtension,MulDivStart,MulDivMorD,MulDivHorL,MulDivSign,MulDivWe,MulDivReady,MemReady;
wire[1:0] M1_WriteRegAddr, M2_WriteRegData,M4_ALUsrcB,ShiftIorR;
wire[2:0] M6_ALUOUTsrc,M8_PCsrc,DataExtensionCtrl;
wire[3:0] State;
wire[4:0] AluCtrl,RS,PrExcCode;
wire[5:0] OP,Funct;
wire[31:0] DPRData,DPWData,Addr;

assign A=Addr[31:2];
assign DPRData=RData;
assign MemReady=Ready;
assign WData=DPWData;
assign RW=~MemWe;
assign Req=(State==`State_Fetch || State==`State_ReadMem || State==`State_WRMem);
assign BE=(State==`State_WRMem)?
            (OP==`OP_SW)?4'b1111:
            (OP==`OP_SH)?(Addr[1])?4'b1100:4'b0011:
            (OP==`OP_SB)?(Addr[1:0]==2'b00)?4'b0001:
                         (Addr[1:0]==2'b01)?4'b0010:
                         (Addr[1:0]==2'b10)?4'b0100:
                         (Addr[1:0]==2'b11)?4'b1000:4'b0000:
            4'b0000:
           4'b0000;
Coco_DataPath DataPath(
Clk,Reset,Compare,PCEn,MemWe,
M1_WriteRegAddr, M2_WriteRegData,M3_ALUsrcA,M4_ALUsrcB,M5_Shift,M6_ALUOUTsrc,M7_CP0Index,M8_PCsrc,M9_CP0Data,M10_Addr,RegWe,IRWrite,
DataExtensionCtrl,EasyExtension,AluCtrl,ShiftIorR,
MulDivStart,MulDivMorD,MulDivHorL,MulDivSign,MulDivWe,MulDivReady,
MemReady,OP,Funct,
Addr,DPRData,DPWData,
Inter,RS,CP0Write,PrExcEnter,PrExcCode,HWInt
);

Coco_Controler Controler(
Clk,Reset,Compare,PCEn,MemWe,
M1_WriteRegAddr, M2_WriteRegData,M3_ALUsrcA,M4_ALUsrcB,M5_Shift,M6_ALUOUTsrc,M7_CP0Index,M8_PCsrc,M9_CP0Data,M10_Addr,RegWe,IRWrite,
DataExtensionCtrl,EasyExtension,AluCtrl,ShiftIorR,
MulDivStart,MulDivMorD,MulDivHorL,MulDivSign,MulDivWe, MulDivReady,
MemReady,OP,Funct,
State,
Inter,RS,CP0Write,PrExcEnter,PrExcCode
);

endmodule
