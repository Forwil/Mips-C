module Coco_MyProject_tb  ; 
 
  reg    Clk   ; 
  reg    Reset   ; 
  initial
   begin
       Reset=0;
       Clk=0;
       #1 Reset=1;
       #1 Reset=0;
   end
  always #5 Clk=~Clk; 
  Coco_MyProject  
   DUT  ( 
       .Clk (Clk ) ,
      .Reset (Reset ) ); 

endmodule

