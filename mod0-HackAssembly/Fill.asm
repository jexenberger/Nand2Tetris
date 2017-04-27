// Program to flip the screen white to black while the keyboard is pressed


(ScanKey)
    @KBD
    D=M
    @SetWhite
    D;JEQ
    @SetBlack
    D;JGT

(SetWhite)
    @0
    D=A
    @colour
    M=D
    @ToggleScreen
    0;JMP
    
(SetBlack)
    @1
    D=-A
    @colour
    M=D
    @ToggleScreen
    0;JMP
    
(ToggleScreen)    
    @ToggleComplete
    D=A
    @return
    M=D
    @0
    D=A
    @offset
    M=D
    @ToggleLoop
    D;JMP 

(ToggleComplete)       
    @ScanKey
    0;JMP

(ToggleLoop)
    // IF (8191 - OFFSET) == 0 THEN WE ARE COMPLETE
    @8191
    D=A    
    @offset
    D=D-M
    @return
    A=M
    D; JEQ

    // ELSE SET POINTER TO SCREEN + @offset and set colour
    @SCREEN
    D=A
    @offset
    D=D+M
    //we store the address of the working pixel
    @pixel
    M=D

    // retrieve the colour and set the pixel
    @colour
    D=M
    @pixel
    A=M
    M=D

    // increment the offset
    @offset
    D=M+1
    M=D

    //LOOP
    @ToggleLoop
    0;JMP
    

(EOF)
    @EOF
    0;JMP