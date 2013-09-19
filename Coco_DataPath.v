`include "Coco_PC.v"
`include "Coco_Mux.v"
`include "Coco_Extension.v"
`include "Coco_Register_File.v"
`include "Coco_MulDiv.v"
`include "Coco_Shift.v"
`include "Coco_Alu.v"
`include "Coco_DataExtension.v"
`include "Register.v"
`include "Coco_CP0.v"
`include "Coco_Excvector.v"

module Coco_DataPath(
input Clk,Reset,
output Compare,
input PCEn,MemWe,
input[1:0] M1_WriteRegAddr, M2_WriteRegData,
input[0:0] M3_ALUsrcA,
input[1:0] M4_ALUsrcB,
input[0:0] M5_Shift,
input[2:0] M6_ALUOUTsrc,
input[0:0] M7_CP0Index,
input[2:0] M8_PCsrc,
input[0:0] M9_CP0Data,
input[0:0] M10_Addr,RegWe,IRWrite,
input[2:0] DataExtensionCtrl,
input[0:0] EasyExtension,
input[4:0] AluCtrl,
input[1:0] ShiftIorR,
input[0:0] MulDivStart,
input[0:0] MulDivMorD,
input[0:0] MulDivHorL,
input[0:0] MulDivSign,
input[0:0] MulDivWe,
output[0:0] MulDivReady,MemReady,
output[5:0] OP,Funct,

output[31:0] Adr,
input[31:0] RData,
output[31:0] WData,

output Inter,

output[4:0] RS,

input CP0Write,PrExcEnter,
input[6:2] PrExcCode,HWInt
);
wire[31:0] M6out,EPCout,Excout,CP0D,M9out,M2out,M3out,M4out,M8out,PCout,ALURout,IR,RDout,DataExtout,RAout,RBout,RD1,RD2,Extout,ALUout,Shiftout,MulDivout;
wire[4:0] M1out,M5out,M7out;


Coco_CP0 CP0(M7out,M9out,CP0Write,PrExcEnter,PrExcCode,HWInt,Clk,Reset,CP0D,Inter,EPCout);
Coco_Excvector Excvector(PrExcCode,Excout);

assign OP=IR[31:26];
assign Funct=IR[5:0];
assign WData=RBout;
assign RS=IR[25:21];

Coco_Mux3x1 #(5)  Mux1(IR[20:16],IR[15:11],5'd31,M1_WriteRegAddr,M1out);
Coco_Mux3x1 #(32) Mux2(ALURout,DataExtout,PCout,M2_WriteRegData,M2out);
Coco_Mux2x1 #(32) Mux3(PCout,RAout,M3_ALUsrcA,M3out);
Coco_Mux4x1 #(32) Mux4(RBout,32'd4,Extout,{Extout[29:0],2'b00},M4_ALUsrcB,M4out);
Coco_Mux2x1 #(5)  Mux5(RAout[4:0],IR[10:6],M5_Shift,M5out);
Coco_Mux5x1 #(32) Mux6(ALUout,Shiftout,MulDivout,Extout,CP0D,M6_ALUOUTsrc,M6out);
Coco_Mux2x1 #(5)  Mux7(5'he,IR[15:11],M7_CP0Index,M7out);
Coco_Mux6x1 #(32) Mux8(ALUout,ALURout,{PCout[31:28],IR[25:0],2'b00},RAout,Excout,EPCout,M8_PCsrc,M8out);
Coco_Mux2x1 #(32) Mux9(RBout,PCout,M9_CP0Data,M9out);
Coco_Mux2x1 #(32) Mux10(PCout,ALURout,M10_Addr,Adr);


Coco_PC            PC(Clk,Reset,M8out,PCEn,PCout);
Coco_DataExtension DataExt(RDout,DataExtensionCtrl,RData[1:0],DataExtout);
Coco_Extension     Ext(IR[15:0],EasyExtension,Extout);
Coco_Alu           Alu(M3out,M4out,AluCtrl,ALUout,Overflow,Compare);
Coco_Shift         Shift(RBout,M5out,ShiftIorR,Shiftout);
Coco_MulDiv        MulDiv(Clk,Reset,RAout,RBout,MulDivStart,MulDivMorD,MulDivHorL,MulDivSign,MulDivWe,MulDivReady,MulDivout);
Coco_Register_File RF(Clk,Reset,IR[25:21],IR[20:16],M1out,RegWe,RD1,RD2,M2out);

Register IRU(Clk,Reset,RData,IRWrite,IR);
Register RD(Clk,Reset,RData,1'b1,RDout);
Register RA(Clk,Reset,RD1,1'b1,RAout);
Register RB(Clk,Reset,RD2,1'b1,RBout);
Register ALURRout(Clk,Reset,M6out,1'b1,ALURout);


endmodule