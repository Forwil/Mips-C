
module Coco_SystemBridge(
input Clk,
input[31:2]PrA,    input[3:0] PrBE,       input[31:0] PrWData,   output[31:0] PrRData,    input PrReq,PrRW, output PrReady,
output[10:0] A_IM, input[31:0] DOut_IM,
output[12:0] A_DM, output[31:0] Din_DM,   output[3:0] BE,          output We_DM, input[31:0] DOut_DM,
output[1:0] A_TC, output[31:0] Din_TC, output We_TC,input[31:0] DOut_TC,
output[31:0] Din_LED,output We_LED,input[31:0] DOut_LED
);
    
    assign PrRData=(PrA[31:16]==32'h_BFC0)?DOut_IM:
                   (PrA[31:16]==32'h_9000)?DOut_DM:
                   (PrA[31:8]==24'ha00002)?DOut_TC:
                   (PrA[31:8]==24'ha00007)?DOut_LED:
                    32'hffff_ffff;
                    
    assign A_IM = PrA[12:2];
    assign A_DM = PrA[14:2];
    assign A_TC = PrA[3:2];
    assign We_DM   =( PrRW==1'b0 &&  PrReq &&PrA[31:16]==32'h_9000);
    assign We_TC   =( PrRW==1'b0 &&  PrReq &&PrA[31:8]==24'ha00002);
    assign We_LED  =( PrRW==1'b0 &&  PrReq &&PrA[31:8]==24'ha00007);
    assign PrReady=PrReq;
    assign Din_DM=PrWData;
    assign Din_TC=PrWData;
    assign Din_LED=PrWData;
    assign BE     =PrBE;
endmodule    