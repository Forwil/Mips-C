module Coco_DataExtension(Din,ExtFunct,A1_A0,ExtDout);
input[31:0] Din;
input[2:0] ExtFunct;
input[1:0] A1_A0;
output[31:0] ExtDout;
wire[31:0] usb,ush,sb,sh;
assign usb={{24'd0},{(A1_A0==2'b00)? Din[7:0]:
                     (A1_A0==2'b01)? Din[15:8]:
                     (A1_A0==2'b10)? Din[23:16]:
                     (A1_A0==2'b11)? Din[31:24]:8'd0}};
                     
assign ush={{16'd0},{(A1_A0==2'b00)?Din[15:0]:
                     (A1_A0==2'b10)?Din[31:16]:16'd0}};
                     
assign sb=(A1_A0==2'b00)?{{24{Din[7]}},Din[7:0]}:
          (A1_A0==2'b01)?{{24{Din[15]}},Din[15:8]}:
          (A1_A0==2'b10)?{{24{Din[23]}},Din[23:16]}:
          (A1_A0==2'b11)?{{24{Din[31]}},Din[31:24]}:32'd0;
                    
assign sh=(A1_A0==2'b00)?{{16{Din[15]}},Din[15:0]}:
          (A1_A0==2'b10)?{{16{Din[31]}},Din[31:16]}:32'b0;
          
assign ExtDout=(ExtFunct==3'b001)?usb:
               (ExtFunct==3'b010)?ush:
               (ExtFunct==3'b011)?sb:
               (ExtFunct==3'b100)?sh:
               (ExtFunct==3'b000)?Din:32'b0;
               
endmodule
