//
//  ASMCode.swift
//  mod1-vmtranslator
//
//  Created by Julian Exenberger on 2017/05/07.
//
//

import Foundation

public func decrementStack() -> [String] {
    return [
        "@SP",
        "M=M-1"
    ]
}

public  func incrementStack() -> [String] {
    return [
        "@SP",
        "M=M+1",
    ]
}

public func restoreFrom(endFrame:String, pointer:String, amt:Int) -> [String] {
    return [
        "@\(amt)",
        "D=A",
        endFrame,
        "D=M-D",
        "A=D",
        "D=M",
        pointer,
        "M=D"
        
    ]
}

public func gotoStack() -> [String] {
    return [
        "@SP",
        "A=M"
    ]
}


public func booleanOp(id:Int = CodeWriter.idCounter, label:String, operation:String) -> [String] {
    return [
        "@\(label).\(id).TRUE",
        "D,\(operation)",
        //false if jump fails
        "D=0",
        "@\(label).\(id).END",
        "0,JMP",
        "(\(label).\(id).TRUE)",
        "D=-1",
        "(\(label).\(id).END)"
    ]
}

public func xor(id:Int = CodeWriter.idCounter) -> [String] {
    return [
        "@XOR.A.\(id)",
        "D=M",
        "@XOR.B.\(id)",
        "D=D&M",
        "D=!D",
        "@XOR.TEMP.\(id)",
        "M=D",
        "@XOR.A.\(id)",
        "D=M",
        "@XOR.B.\(id)",
        "D=D|M",
        "@XOR.TEMP.\(id)",
        "D=D&M",
        "@XOR.RESULT.\(id)",
        "M=D"
    ]
}

public func loadStack() -> [String] {
    return [
        "@SP",
        "A=M",
        "D=M"
    ]
}

public func initPointer(_ pntr:String, at:Int) -> [String] {
    return [
        "@\(at) //Initialise pointer \(pntr)",
        "D=A",
        pntr,
        "M=D"
    ]
}

public func storeStack() -> [String] {
    return [
        "@SP",
        "A=M",
        "M=D"
    ]
}

public func storeAndIncrementPointers(pntrs:String ...) -> [String]{
    var ary = [String]()
    for pntr in pntrs {
        ary.append(pntr+" //Storing the current value of \(pntr)")
        ary.append("D=M")
        ary.append(contentsOf: storeAndIncrementStack())
    }
    return ary
}

public func storeAndIncrementStack() -> [String] {
    var ary = [String]()
    ary.append(contentsOf: storeStack())
    ary.append(contentsOf: incrementStack())
    return ary
}

public  func setAddr(to:String, offset:Int = 0) -> [String] {
    //handle direct addressing
    let target = Int(to)
    if (target != nil) {
        return [
            "@\(target! + offset)"
        ]
    }
    
    if offset > 0 {
        return [
            "@\(offset)",
            "D=A",
            "@\(to)",
            "A=M+D"
        ]
    }
    return [
        "@\(to)",
        "A=M"
    ]
    
}
