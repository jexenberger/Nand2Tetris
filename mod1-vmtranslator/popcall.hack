// BEGIN LINE 1 (	init  )
@16
D=A
@LCL
M=D
@8
D=A
@SP
M=D
// ~ LINE  1


// BEGIN LINE 2 (	push constant 123)
@123	//push constant 123
D=A
@SP
A=M
M=D

@SP
M=M+1

// ~ LINE  2


// BEGIN LINE 3 (	pop local 3)

//GOTO LCL offset 3
@3
D=A
@LCL
A=M+D

D=A
@LCL.REG	//Store address in staging memory area
M=D

//decrement stack
@SP
D=M-1
M=D

@SP
A=M
D=M	//got stack value
@LCL.REG	//get address from register
A=M
M=D	//store stack value in address
// ~ LINE  3
