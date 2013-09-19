`include "Coco_Define.v"
module Coco_Controler(
input Clk,Reset,Compare,
output PCEn,MemWe,
output[1:0] M1_WriteRegAddr, M2_WriteRegData,
output[0:0] M3_ALUsrcA,
output[1:0] M4_ALUsrcB,
output[0:0] M5_Shift,
output[2:0] M6_ALUOUTsrc,
output[0:0] M7_CP0Index,
output[2:0] M8_PCsrc,
output[0:0] M9_CP0Data,
output[0:0] M10_Addr,RegWe,IRWrite,
output[2:0] DataExtensionCtrl,
output[0:0] EasyExtension,
output[4:0] AluCtrl,
output[1:0] ShiftIorR,
output[0:0] MulDivStart,
output[0:0] MulDivMorD,
output[0:0] MulDivHorL,
output[0:0] MulDivSign,
output[0:0] MulDivWe,
input MulDivReady,MemReady,
input[5:0] OP,Funct,
output[3:0] LState,


input Inter,

input[4:0] RS,

output CP0Write,PrExcEnter,
output[6:2] PrExcCode
);
reg[3:0] State;

assign CP0Write=(State==`State_Other && RS==`RS_MTC0)||(State==`State_SCBPexc || State==`State_Interr);
assign PrExcEnter=(State==`State_SCBPexc || State==`State_Interr);
assign PrExcCode=(OP==`OP_Rtype && Funct==`Funct_SYSCALL)?5'd8:
                 (OP==`OP_Rtype && Funct==`Funct_BREAK)?5'd9:
                  5'd0;

assign LState=State;
assign PCEn=(State==`State_Fetch || 
             State==`State_Jump ||
            (State==`State_Branch && Compare)||
            (State==`State_Interr)||
            (State==`State_SCBPexc)||
            (State==`State_Other && RS==`RS_ERET));

assign MemWe=(State==`State_WRMem);

assign M1_WriteRegAddr=(State==`State_ALUWB && OP ==`OP_Rtype)?2'b01:
                       (State==`State_Jump && OP ==`OP_JAL)?2'b10:
                       (State==`State_Jump && Funct ==`Funct_JALR)?2'b01: 2'b00;
                        

assign M2_WriteRegData=(State==`State_RWReg)?2'b01:
                       (State==`State_Jump)?2'b10: 2'b00; 
                       
assign M3_ALUsrcA=(State==`State_MemOP || State==`State_SimR || State==`State_SimI || State==`State_Branch);
assign M4_ALUsrcB=(State==`State_Fetch )?2'b01:
                  (State==`State_Decode )?2'b11:
                  (State==`State_MemOP ||State==`State_SimI)?2'b10: 2'b00;
assign M5_Shift=(State==`State_Shift &&(Funct == `Funct_SLL ||
                                        Funct == `Funct_SRL ||
                                        Funct == `Funct_SRA ));
assign M6_ALUOUTsrc=(State==`State_Shift)?2'b01:
                    (State==`State_MulDiv)?2'b10: 2'b00;

assign M7_CP0Index=(State==`State_Other && 
                     (RS==`RS_MFC0 || RS==`RS_MTC0))? 1'b1:1'b0;

assign M8_PCsrc=(State==`State_Jump && OP==`OP_Rtype && (Funct==`Funct_JR ||Funct==`Funct_JALR))?3'b011:
                (State==`State_Jump && (OP==`OP_J ||OP==`OP_JAL))?3'b010:
                (State==`State_Branch)?3'b001:
                (State==`State_Interr|| State==`State_SCBPexc)?3'b100:
                (State==`State_Other && RS==`RS_ERET)?3'b101:
                 3'b000;

assign M9_CP0Data=(State==`State_Interr || State==`State_SCBPexc)?1'b1:1'b0;

assign M10_Addr=(State==`State_WRMem || State==`State_ReadMem);

assign RegWe=(State==`State_RWReg || State==`State_ALUWB ||
             (State==`State_Jump && (OP==`OP_JAL ||Funct==`Funct_JALR)));
assign IRWrite=(State==`State_Fetch);
assign DataExtensionCtrl=(State==`State_ReadMem && OP ==`OP_LBU )?3'b001:
                         (State==`State_ReadMem && OP ==`OP_LHU )?3'b010:
                         (State==`State_ReadMem && OP ==`OP_LB )? 3'b011:
                         (State==`State_ReadMem && OP ==`OP_LH )? 3'b100:
                         (State==`State_ReadMem && OP ==`OP_LW )? 3'b000:3'b000;

assign EasyExtension=(State==`State_Decode || 
                      State==`State_MemOP ||
                     (State==`State_SimI &&
                        (
                           OP==`OP_ADDIU ||
                           OP==`OP_ADDI  ||
                           OP==`OP_SLTI ||
                           OP==`OP_SLTIU
                         )));

assign AluCtrl=(State==`State_Fetch)?`ALU_ADDU:
               (State==`State_Decode)?`ALU_ADD:
               (State==`State_MemOP)?`ALU_ADD:
               (State==`State_Fetch)?`ALU_ADDU:
               (State==`State_SimR)?
                  (Funct==`Funct_ADD)? `ALU_ADD:
                  (Funct==`Funct_ADDU)?`ALU_ADDU:
                  (Funct==`Funct_AND)? `ALU_AND:
                  (Funct==`Funct_NOR)? `ALU_NOR:
                  (Funct==`Funct_OR)?  `ALU_OR:
                  (Funct==`Funct_SUB)? `ALU_SUB:
                  (Funct==`Funct_SUBU)?`ALU_SUBU:
                  (Funct==`Funct_XOR)? `ALU_XOR:
                  (Funct==`Funct_SLT)? `ALU_SLT:
                  (Funct==`Funct_SLTU)?`ALU_SLTU:5'b00000:
               (State==`State_SimI)?
                  (OP==`OP_ADDI)? `ALU_ADD:
                  (OP==`OP_ADDIU)?`ALU_ADDU:
                  (OP==`OP_ANDI)? `ALU_AND:
                  (OP==`OP_ORI)?  `ALU_OR:
                  (OP==`OP_XORI)? `ALU_XOR:
                  (OP==`OP_SLTI)? `ALU_SLT:
                  (OP==`OP_SLTIU)?`ALU_SLTU:
                  (OP==`OP_LUI)?  `ALU_LUI:5'b00000:
                (State==`State_Branch)?
                  (OP==`OP_BLEZ)?  `ALU_BLEZ:
                  (OP==`OP_BGTZ)?  `ALU_BGTZ:
                  (OP==`OP_BGEZ)?  `ALU_BGEZ:
                  (OP==`OP_BEQ)?   `ALU_BEQ:
                  (OP==`OP_BNE)?   `ALU_BNE: 5'b00000:
                  5'b00000;
                
                  
assign ShiftIorR=(Funct==`Funct_SLL || Funct==`Funct_SLLV)?2'b10:
                 (Funct==`Funct_SRL || Funct==`Funct_SRLV)?2'b01:
                 (Funct==`Funct_SRA || Funct==`Funct_SRAV)?2'b00:2'b00;

assign MulDivStart=(State==`State_MulDiv && (Funct==`Funct_MULT || Funct ==`Funct_DIV ||Funct==`Funct_MULTU || Funct ==`Funct_DIVU));
assign MulDivMorD =(State==`State_MulDiv && (Funct==`Funct_MULT  || Funct==`Funct_MULTU));
assign MulDivHorL =(State==`State_MulDiv && (Funct==`Funct_MFHI || Funct==`Funct_MTHI));
assign MulDivSign =(State==`State_MulDiv && (Funct==`Funct_MULTU || Funct==`Funct_DIVU));
assign MulDivWe   =(State==`State_MulDiv && (Funct==`Funct_MTHI || Funct==`Funct_MTLO));

always @(posedge Clk,posedge Reset)
 if (Reset) 
    State<=`State_Fetch;
 else
    case(State)
    
    `State_Fetch: State<=(MemReady)?`State_Decode:`State_Fetch;
    
    `State_Decode:
      begin 
          if (OP == `OP_LBU ||
           OP == `OP_LHU ||  
           OP == `OP_LB  ||
           OP == `OP_LH  ||
           OP == `OP_LW  ||
           OP == `OP_SB  ||
           OP == `OP_SH  ||
           OP == `OP_SW  )
           State<=`State_MemOP;
        
          if (OP == `OP_Rtype &&
           (Funct == `Funct_ADD ||
            Funct == `Funct_ADDU ||
            Funct == `Funct_AND ||
            Funct == `Funct_NOR ||
            Funct == `Funct_OR ||
            Funct == `Funct_SUB ||
            Funct == `Funct_SUBU ||
            Funct == `Funct_XOR ||
            Funct == `Funct_SLT ||
            Funct == `Funct_SLTU))
           State<=`State_SimR;
           
          if (OP == `OP_ADDI ||
             OP == `OP_ADDIU ||
             OP == `OP_ANDI ||
             OP == `OP_ORI ||
             OP == `OP_XORI ||
             OP == `OP_LUI ||
             OP == `OP_SLTI ||
             OP == `OP_SLTIU)
           State<=`State_SimI;
           
          if (OP == `OP_Rtype &&
             (Funct == `Funct_SLL ||
              Funct == `Funct_SRL ||
              Funct == `Funct_SRA ||
              Funct == `Funct_SRLV ||
              Funct == `Funct_SRAV ||
              Funct == `Funct_SLLV
             ))  
            State<=`State_Shift;
            
          if (OP == `OP_J    ||
              OP == `OP_JAL  ||
             (OP == `OP_Rtype &&
             (Funct == `Funct_JR || Funct == `Funct_JALR)))
            State<=`State_Jump;
           
          if (OP == `OP_BEQ  ||
              OP == `OP_BGEZ ||
              OP == `OP_BGTZ ||
              OP == `OP_BLEZ ||
              OP == `OP_BLTZ ||
              OP == `OP_BNE  )  
            State<=`State_Branch;
            
          if (OP == `OP_Rtype &&
             (Funct == `Funct_DIV ||
              Funct == `Funct_DIVU ||
              Funct == `Funct_MULT ||
              Funct == `Funct_MULTU ||
              Funct == `Funct_MFHI ||
              Funct == `Funct_MFLO ||
              Funct == `Funct_MTHI ||
              Funct == `Funct_MTLO))
            State<=`State_MulDiv;
            
           if (OP==`OP_Rtype && (Funct == `Funct_BREAK||Funct == `Funct_SYSCALL))
            State<=`State_SCBPexc;
           if (OP==`OP_OTHER)
            State<=`State_Other;
       end //end of State_Decode
       
     `State_MemOP:
       begin
       if (OP == `OP_LBU ||
           OP == `OP_LHU ||
           OP == `OP_LB  ||
           OP == `OP_LH  ||
           OP == `OP_LW )
           State<=`State_ReadMem;
       if (OP == `OP_SB  ||
           OP == `OP_SH  ||
           OP == `OP_SW )
           State<=`State_WRMem;   
       end  //end of State_MemOP
       
      `State_ReadMem:
       State<=`State_RWReg;
       
      `State_WRMem:
       State<=(Inter)?`State_Interr:`State_Fetch;
       
      `State_RWReg:
       State<=(Inter)?`State_Interr:`State_Fetch;
                       
      `State_SimR:
       State<=`State_ALUWB;
       
      `State_SimI:
       State<=`State_ALUWB;
       
      `State_Shift:
       State<=`State_ALUWB;
       
      `State_ALUWB:
       State<=(Inter)?`State_Interr:`State_Fetch;
       
      `State_Jump:
       State<=(Inter)?`State_Interr:`State_Fetch;
       
      `State_Branch:
       State<=(Inter)?`State_Interr:`State_Fetch;
       
      `State_MulDiv:
       begin
        if  (Funct == `Funct_MFHI ||
             Funct == `Funct_MFLO )
          State<=`State_ALUWB;
        else       
        if (Funct == `Funct_MULT  ||
            Funct == `Funct_MULTU ||
            Funct == `Funct_DIV  ||
            Funct == `Funct_DIVU)
         State<=(MulDivReady)?((Inter)?`State_Interr:`State_Fetch):`State_MulDiv;
        else 
         State<=(Inter)?`State_Interr:`State_Fetch; 
       end
       
       `State_SCBPexc:
       State<=`State_Fetch;
       
       `State_Other:
       State<=(RS==`RS_MFC0)?`State_ALUWB:`State_Fetch;
       
       `State_Interr:
       State<=`State_Fetch;
       endcase
endmodule