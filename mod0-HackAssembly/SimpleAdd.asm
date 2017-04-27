// program to add two numbers in Hack
// adds numbers in R0 and R1 giving R2
    @R0
    D=M
    @R1
    D=D+M
    @R2
    M=D
(LOOP)
    @LOOP
    0;JMP



