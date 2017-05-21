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


// BEGIN LINE 2 (	push constant 10)
@10	//push constant 10
D=A

@SP
A=M
M=D


@SP
M=M+1

// ~ LINE  2


// BEGIN LINE 2 (	push constant 10)
@10	//push constant 10
D=A

@SP
A=M
M=D


@SP
M=M+1

// ~ LINE  2


// BEGIN LINE 2 (	add  )

@SP
M=M-1


@SP
A=M
D=M


@SP
M=M-1


@SP
A=M

M=D+M

@SP
M=M+1

// ~ LINE  2
