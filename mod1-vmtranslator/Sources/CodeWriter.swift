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

    static public func +=(this:CodeEmission, _ intr:[String]) -> CodeEmission {
        for instr in intr {
            this.append(instr)

        }
        return this
    }
}



class CodeWriter {

    
    typealias Emitter = (VMExpression)-> CodeEmission;
    lazy var emitters = [String:Emitter]()
    let fileName:String
    
    init(fileName:String) {
        self.fileName = fileName
    }
    
    
    private  func segmentName(for value:String) -> String{
        let memMap = [
            "local" : "LCL",
            "static" : "N/A",
            "this" : "THIS",
            "that" : "THAT",
            "pointer" : "N/A",
            "argument" : "ARG"
        ]
        return memMap[value]!
    }
    
    private func decrementStack() -> [String] {
        return [
            "@SP",
            "M=A-1"
        ]
    }
    
    private func incrementStack() -> [String] {
        return [
            "@SP",
            "M=A+1",
        ]
    }
    
    private func setAddr(to:String, offset:Int = 0) -> [String] {
        
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
    
    
    
    private func popCall(expr:VMExpression) -> Emitter {

            let seg = expr.arg0!
            let hackAddr = "@\(self.segmentName(for: seg))"
            let pos = expr.arg1!
            let emission = CodeEmission(expr:expr)
            
            if (seg == "static") {
                return emission
                    + "@SP"
                    + "D=M"
                    + "D=D-1"
                    + "A=D"
                    + "D=M"
                    + "@\(self.fileName).\(pos)"
                    + "M=D"
            }
            
            return emission
                += self.decrementStack()
                += self.setAddr(to: seg, offset: Int(pos))
                + "@\(seg).REG"
                + "M=A"
                + "@SP"
                + "D=M"
                + "@\(seg).REG"
                + "A=M"

    }
    
    
    private func pushCall() -> (String, (VMExpression)-> CodeEmission) {
        return ("push", { expr in
            let seg = expr.arg0!
            let hackAddr = "@\(segmentName(for: seg))"
            let pos = "@\(expr.arg1!)"
            let emission = CodeEmission(expr:expr)
            if (seg == "constant") {
                return emission
                    + "@\(pos)"
                    + "D=A"
                    + "@SP"
                    + "A=M"
                    + "M=D"
            }
            if seg == "static" {
                return emission
                    + "@\(self.fileName).\(pos)"
                    + "D=M"
                    + "@SP"
                    + "A=M"
                    + "M=D"
            }
            return emission
                += setAddr(to: seg, offset: Int(pos))
                + "D=M"
                + "@SP"
                + "A=M"
                + "M=D"
                += incrementStack()
        })
    }

    
    
}
