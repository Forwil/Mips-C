module Coco_Mux2x1(In0,In1,Sel,Out);
parameter N=1;
input[N-1:0] In0,In1;
input Sel;
output[N-1:0] Out;
assign Out=(Sel==0)?In0:In1;
endmodule

module Coco_Mux3x1(In0,In1,In2,Sel,Out);
parameter N=1;
input[N-1:0] In0,In1,In2;
input[1:0] Sel;
output[N-1:0] Out;
assign Out=(Sel==2'b00)?In0:
           (Sel==2'b01)?In1:
           (Sel==2'b10)?In2:1'd0; 
endmodule

module Coco_Mux4x1(In0,In1,In2,In3,Sel,Out);
parameter N=1;
input[N-1:0] In0,In1,In2,In3;
input[1:0] Sel;
output[N-1:0] Out;
assign Out=(Sel==2'b00)?In0:
           (Sel==2'b01)?In1:
           (Sel==2'b10)?In2:
           (Sel==2'b11)?In3:1'd0; 
endmodule

module Coco_Mux5x1(In0,In1,In2,In3,In4,Sel,Out);
parameter N=1;
input[N-1:0] In0,In1,In2,In3,In4;
input[2:0] Sel;
output[N-1:0] Out;
assign Out=(Sel==3'b000)?In0:
           (Sel==3'b001)?In1:
           (Sel==3'b010)?In2:
           (Sel==3'b011)?In3:
           (Sel==3'b100)?In4:1'd0; 
endmodule

module Coco_Mux6x1(In0,In1,In2,In3,In4,In5,Sel,Out);
parameter N=1;
input[N-1:0] In0,In1,In2,In3,In4,In5;
input[2:0] Sel;
output[N-1:0] Out;
assign Out=(Sel==3'b000)?In0:
           (Sel==3'b001)?In1:
           (Sel==3'b010)?In2:
           (Sel==3'b011)?In3:
           (Sel==3'b100)?In4:
           (Sel==3'b101)?In5:1'd0; 
endmodule

module Coco_Mux7x1(In0,In1,In2,In3,In4,In5,In6,Sel,Out);
parameter N=1;
input[N-1:0] In0,In1,In2,In3,In4,In5,In6;
input[2:0] Sel;
output[N-1:0] Out;
assign Out=(Sel==3'b000)?In0:
           (Sel==3'b001)?In1:
           (Sel==3'b010)?In2:
           (Sel==3'b011)?In3:
           (Sel==3'b100)?In4:
           (Sel==3'b101)?In5:
           (Sel==3'b110)?In6:1'd0; 
endmodule

