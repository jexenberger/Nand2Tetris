// BEGIN LINE 1 (	init  )
@64
D=A
@LCL
M=D
@32
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


// BEGIN LINE 3 (	pop temp 3)

//GOTO 5 offset 3
@8

D=A
@5.REG	//Store address in staging memory area
M=D

//decrement stack
@SP
D=M-1
M=D


//loaded stack to D
@SP
A=M
D=M

@5.REG	//get address from register
A=M
M=D	//store stack value in address
// ~ LINE  3
