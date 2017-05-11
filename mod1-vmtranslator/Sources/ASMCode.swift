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
    
    if offset > 1 {
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
