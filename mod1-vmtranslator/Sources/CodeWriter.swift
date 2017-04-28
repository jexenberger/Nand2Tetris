//
//  CodeWriter.swift
//  mod1-vmtranslator
//
//  Created by Julian Exenberger on 2017/04/27.
//
//

import Foundation

class CodeEmission  {
    let expr:VMExpression
    lazy var instrs:[String] = []
    
    init(expr:VMExpression) {
        self.expr = expr
    }
    
    public func asString() -> String{
        let start = "// BEGIN LINE \(expr.line) (\(expr.asString()))"
        let end = "// ~ LINE  \(expr.line)\n\n"
        return "\(start)\n\(instrs.map({i in "\t\(i)"}).joined(separator: "\n"))\n\(end)"
    }
    
    public func append(_ instr:String) -> CodeEmission {
        instrs.append(instr)
        return self
    }
    
    static public func +(this:CodeEmission, _ intr:String) -> CodeEmission {
        return this.append(intr)
    }
    
    
}


class CodeWriter {
    lazy var emitters = [String:(VMExpression)-> CodeEmission]()
    
    init() {
        
    }
    
    private func popCall() -> (String, (VMExpression)-> CodeEmission) {
        return ("pop", { expr in
            let seg = "@\(expr.arg0!)"
            let pos = "@\(expr.arg1!)"
            let emission = CodeEmission(expr:expr)
            return emission
                    + seg
                    + "D=M"
                    + pos
                    + "D=D+A"
                    + "A=D"
                    + "D=M"
                    + "@SP"
                    + "D=M-1"
                    + "M=D"
        })
    }
    
    private func pushCall() -> (String, (VMExpression)-> CodeEmission) {
        return ("push", { expr in
            let seg = "@\(expr.arg0!)"
            let pos = "@\(expr.arg1!)"
            let emission = CodeEmission(expr:expr)
            return emission
                + seg
                + "D=M"
                + pos
                + "D=D+A"
                + "A=D"
                + "D=M"
                + "@SP"
                + "D=M-1"
                + "M=D"
        })
    }
    
    
}
