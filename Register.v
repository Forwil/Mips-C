module Register(Clk,Reset,WData,Wr,Dout);
   parameter N = 32;
   input Clk,Reset,Wr;
   input[N-1:0] WData;
   output[N -1:0] Dout;
   reg[N-1:0] Dout;
   
   always @(posedge Clk  or posedge Reset)
    if (Reset)
        Dout<=32'h0000_0000;
    else
       if (Wr) Dout<=WData; 
endmodule
