// BEGIN LINE 3 (	init  )
	@64
	D=A
	@LCL
	M=D
	@32
	D=A
	@SP
	M=D
// ~ LINE  3

// BEGIN LINE 4 (	push constant 8)
	@8	//push constant 8
	D=A
	
	@SP
	A=M
	M=D
	
	
	@SP
	M=M+1
	
// ~ LINE  4

// BEGIN LINE 5 (	push constant 9)
	@9	//push constant 9
	D=A
	
	@SP
	A=M
	M=D
	
	
	@SP
	M=M+1
	
// ~ LINE  5

// BEGIN LINE 6 (	add  )
	
	@SP
	M=M-1
	
	
	@SP
	A=M
	D=M
	
	
	@SP
	M=M-1
	
	
	@SP
	A=M
	
	D=D+M
	
	@SP
	A=M
	
	M=D
	
	@SP
	M=M+1
	
// ~ LINE  6

// BEGIN LINE 8 (	push constant 17)
	@17	//push constant 17
	D=A
	
	@SP
	A=M
	M=D
	
	
	@SP
	M=M+1
	
// ~ LINE  8

// BEGIN LINE 9 (	eq  )
	
	@SP
	M=M-1
	
	
	@SP
	A=M
	D=M
	
	@XOR.A.1
	M=D
	
	@SP
	M=M-1
	
	
	@SP
	A=M
	D=M
	
	@XOR.B.1
	M=D
	
	@XOR.A.1
	D=M
	@XOR.B.1
	D=D&M
	D=!D
	@XOR.TEMP.1
	M=D
	@XOR.A.1
	D=M
	@XOR.B.1
	D=D|M
	@XOR.TEMP.1
	D=D&M
	@XOR.RESULT.1
	M=D
	
	@XOR.RESULT.1
	D=M
	
	@EQ.1.TRUE
	D,JEQ
	D=0
	@EQ.1.END
	0,JMP
	(EQ.1.TRUE)
	D=1
	(EQ.1.END)
	
	
	@SP
	A=M
	
	M=D
	
	@SP
	M=M+1
	
// ~ LINE  9

// BEGIN LINE 10 (	pop local 1)
	
	//GOTO LCL offset 1
	@LCL
	A=M
	
	D=A
	@LCL.REG.2	//Store address in staging memory area
	M=D
	
	//decrement stack
	@SP
	M=M-1
	
	
	//loaded stack to D
	@SP
	A=M
	D=M
	
	@LCL.REG.2	//get address from register
	A=M
	M=D	//store stack value in address
// ~ LINE  10

