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


// BEGIN LINE 3 (	pop static 3)

//decrement stack
@SP
D=M-1
M=D


@SP
A=M
D=M

@test.3
M=D
// ~ LINE  3
