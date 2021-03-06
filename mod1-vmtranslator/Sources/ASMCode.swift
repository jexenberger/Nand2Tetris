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

public func storeStack() -> [String] {
    return [
        "@SP",
        "A=M",
        "M=D"
    ]
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
