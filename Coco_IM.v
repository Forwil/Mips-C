module Coco_IM(
input[1+11:2]A,
output[31:0]Din);
    parameter N=11;
 
    reg[31:0] IM[1<<N -1:0];
    
    initial 
     begin
        $readmemh("test2.txt",IM); 
     end
     
    assign Din=IM[A];
 endmodule    