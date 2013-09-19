module Coco_Extension(Imm16,ExtFunct,ExtImm32);
input[15:0] Imm16;
input ExtFunct;
output[31:0] ExtImm32;
assign ExtImm32=(ExtFunct==0)? {16'b0,Imm16}:{{16{Imm16[15]}},Imm16};
endmodule
