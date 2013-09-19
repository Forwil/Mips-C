`define OP_Rtype 6'b000000
`define OP_ADDI  6'b001000
`define OP_ADDIU 6'b001001
`define OP_SLTI  6'b001011
`define OP_SLTIU 6'b001011
`define OP_ANDI  6'b001100
`define OP_ORI   6'b001101
`define OP_XORI  6'b001110
`define OP_LUI   6'b001111
`define OP_BEQ   6'b000100
`define OP_BGEZ  6'b000001
`define OP_BGTZ  6'b000111
`define OP_BLEZ  6'b000110
`define OP_BLTZ  6'b000001
`define OP_BNE   6'b000101
`define OP_J     6'b000010
`define OP_JAL   6'b000011
`define OP_LBU   6'b100100
`define OP_LHU   6'b100101
`define OP_LB    6'b100000
`define OP_LH    6'b100001
`define OP_LW    6'b100011
`define OP_SB    6'b101000
`define OP_SH    6'b101001
`define OP_SW    6'b101011
`define OP_OTHER 6'b010000

`define RT_BGEZ  5'b00001
`define RT_BLTZ  5'b00000


`define Funct_ADD   6'b100000
`define Funct_ADDU  6'b100001
`define Funct_DIV   6'b011010
`define Funct_DIVU  6'b011011
`define Funct_MULT  6'b011000
`define Funct_MULTU 6'b011001
`define Funct_NOR   6'b100111
`define Funct_XOR   6'b100110
`define Funct_SLL   6'b000000
`define Funct_SRL   6'b000010
`define Funct_SRA   6'b000011
`define Funct_SRLV  6'b000110
`define Funct_SRAV  6'b000111
`define Funct_SLLV  6'b000100
`define Funct_SUBU  6'b100011
`define Funct_SLT   6'b101010
`define Funct_SLTU  6'b101011
`define Funct_JR    6'b001000
`define Funct_JALR  6'b001001
`define Funct_BREAK 6'b001101
`define Funct_SYSCALL 6'b001100
`define Funct_MFHI  6'b010000
`define Funct_MFLO  6'b010010
`define Funct_MTHI  6'b010001
`define Funct_MTLO  6'b010011 
`define Funct_SUB   6'b100010
`define Funct_AND   6'b100100
`define Funct_OR    6'b100101

`define RS_ERET 5'b10000
`define RS_MFC0 5'b00000
`define RS_MTC0 5'b00100


`define State_Fetch   4'b0000
`define State_Decode  4'b0001
`define State_MemOP   4'b0010
`define State_ReadMem 4'b0011
`define State_RWReg   4'b0100
`define State_WRMem   4'b0101
`define State_SimR    4'b0110
`define State_SimI    4'b0111
`define State_Shift   4'b1000
`define State_ALUWB   4'b1001
`define State_Jump    4'b1010
`define State_Branch   4'b1011
`define State_MulDiv  4'b1100 
`define State_Interr  4'b1101 
`define State_SCBPexc   4'b1110
`define State_Other   4'b1111

`define ALU_ADDU 5'b00001
`define ALU_ADD  5'b00010
`define ALU_SUBU 5'b00011
`define ALU_SUB  5'b00100
`define ALU_AND  5'b00101
`define ALU_OR   5'b00110
`define ALU_NOR  5'b00111
`define ALU_XOR  5'b01000
`define ALU_SLTU 5'b01001
`define ALU_SLT  5'b01010
`define ALU_BLTZ 5'b01011
`define ALU_BLEZ 5'b01100
`define ALU_BGTZ 5'b01101
`define ALU_BGEZ 5'b01110
`define ALU_BEQ  5'b01111
`define ALU_BNE  5'b10000
`define ALU_LUI  5'b10001 