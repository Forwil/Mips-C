module Coco_Excvector(
input[6:2] ExcCode,
output[31:0] Vector
);
assign Vector=(ExcCode==5'b0)?32'hBFC00400:
              (ExcCode==5'd8||
               ExcCode==5'd9||
               ExcCode==5'd10)?32'hBFC00380:32'h00000000;   
endmodule