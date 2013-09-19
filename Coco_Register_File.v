module Coco_Register_File(Clk,Reset,RS1,RS2,RD,RegWrite,RData1,RData2,WData);
    input Clk,Reset,RegWrite;
    input[4:0] RS1,RS2,RD;
    input[31:0] WData;
    output     RData1,RData2;
    wire[31:0] RData1,RData2,WData,kan;
    reg[31:0] RegFile[31:1];
    integer i;

  assign kan=RegFile[10];
assign RData1=(RS1)?RegFile[RS1]:32'b0;         
assign RData2=(RS2)?RegFile[RS2]:32'b0;          
    always @(posedge Clk or posedge Reset )
    if (Reset)
       begin
        for (i=1;i<=31;i=i+1)
        RegFile[i]<=32'd0;
       end
    else if(RegWrite && RD!=32'b0) RegFile[RD]<=WData; 

endmodule