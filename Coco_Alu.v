`include "Coco_Define.v"

module Coco_Alu(A,B,Ctrl,C,Overflow,Compare);
input[31:0] A,B;
input[4:0] Ctrl;
output[31:0] C;
output Overflow,Compare;

assign C = (Ctrl==`ALU_ADDU)? A + B:
           (Ctrl==`ALU_ADD )? A + B:
           (Ctrl==`ALU_SUBU)? A + (~B + 1):
           (Ctrl==`ALU_SUB )? A + (~B + 1):
           (Ctrl==`ALU_AND )? A & B:
           (Ctrl==`ALU_OR  )? A | B:
           (Ctrl==`ALU_NOR )? ~(A | B):
           (Ctrl==`ALU_XOR )? A ^ B:
           (Ctrl==`ALU_SLTU)? (A < B)?32'd1:32'd0 :
           (Ctrl==`ALU_SLT )? (A < B)?32'd1:32'd0 :
           (Ctrl==`ALU_LUI)?{B[15:0],B[31:16]}:
           32'd0;

assign Compare=(Ctrl==`ALU_BLTZ)? (A < 0 ):
               (Ctrl==`ALU_BLEZ)? (A <=0 ):
               (Ctrl==`ALU_BGTZ)? (A > 0 ):
               (Ctrl==`ALU_BGEZ)? (A >=0 ):
               (Ctrl==`ALU_BEQ )? (A ==B ):
               (Ctrl==`ALU_BNE)? (A !=B ):1'd0;
endmodule           
