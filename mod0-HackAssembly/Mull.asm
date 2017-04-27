// Multiplies two numbers together in Hack
// Multiplication is the sum of number x added together n times
// for example 2 * 3  
// x = 3
// n = 2
// sum = x + x + x
// For this program we multiply R0 with R1
//
// Multiplication is designed to be re-usable (so we can use it in the next assignment)
// Basically we hold a return instruction @return which is used to return control back 
// to a point in memory.
//
// Multiply expects the following parameters:
// - @multiplier   : the value of the multiplier
// - @multiplicand : the value of the multiplicand
// - @return       : the value of the instruction to jump back to once multiplication is complete
//
// Multiplier returns the following parameters:
// - @multiplication : This holds the value of the multiplication


(Main)
    @R0
    D=M
    @multiplier
    M=D
    @R1
    D=M
    @multiplicand
    M=D

    // set the return instruction label to be "Finished"
    @Finished
    D=A
    @return
    M=D

    // run the multiplication
    @Multiply
    0;JMP

(Finished)
    @multiplication
    D=M
    @R2
    M=D
    @EOF
    0;JMP

// --- Multiply function    
  
(Multiply)
    // init counter
    @0
    D=A
    @counter        //this address is going to act as our counter to check if have added N times
    M=D

    // set the result of zero if multiplicand == 0
    @multiplicand 
    D=M
    @SetToZero
    D;JEQ

(AddAnotherNumber)    
    // Multiplication is the Sum of a set of the same number N times where N is the multiplicand
    // EG: 3 * 4 is the same as Sum(3 + 3 + 3 + 3)
    // Therefore the logic is to add accumulate the multiplier into the multiplication 
    // result multiplicand times
    @multiplier
    D=M         // add multiplier to D
    @multiplication
    M=D+M       // accumulate result into Multiplication


    // IF (COUNTER - MULTIPLICAND) == 0 JUMP TO @MultiplicationFinished
    // increment the counter to 1
    // if the counter minus the multiplicand is zero it means we have 
    // iterated multiplicand times and the multiplication is complete
    @counter
    D=M
    D=D+1       
    M=D         //increment counter
    @multiplicand
    D=M-D
    @MultiplicationFinished
    D;JEQ       //jump to "MultiplicationFinished" if we have added multiplicand times

    // ELSE LOOP
    @AddAnotherNumber
    D;JMP       // reloop

(MultiplicationFinished)
    // first clean up clean up by resetting all the temporary variables
    @0
    D=A
    @counter
    M=D
    @multiplier
    M=D
    @multiplicand
    M=D
    // jump to the return instruction
    @return
    A=M
    0;JMP

(SetToZero)
    // this should only get invoked if the @multiplicand is zero
    // here we simply make sure the @multiplication is set of zero
    // then we jump to @MultiplicationFinished    
    @0
    D=A
    @multiplication
    M=0
    @MultiplicationFinished
    0;JMP

// --- End Multiply function    


(EOF)
    @EOF
    0;JMP

