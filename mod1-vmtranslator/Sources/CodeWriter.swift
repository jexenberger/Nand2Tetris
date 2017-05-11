//
//  CodeWriter.swift
//  mod1-vmtranslator
//
//  Created by Julian Exenberger on 2017/04/27.
//
//

import Foundation


public class CodeEmission  {
    let expr:VMExpression
    lazy var instrs:[(String,String?)] = []
    
    init(expr:VMExpression) {
        self.expr = expr
    }
    
    public func asString() -> String{
        let start = "// BEGIN LINE \(expr.line) (\(expr.asString()))"
        let end = "// ~ LINE  \(expr.line)\n\n"
        return "\(start)\n\(instrs.map({(i,x) in "\t\(i)" + (x != nil ? "\t//\(x!)" : "")}).joined(separator: "\n"))\n\(end)"
    }
    
    public func append(_ instr:String, comment:String? = nil) -> CodeEmission {
        instrs.append((instr, comment))
        return self
    }
    
    public func append(ary instr:[String], comment:String? = nil) -> CodeEmission {
        _ = self.append("")
        if (comment != nil) {
            _ = self.append("//\(comment!)")
        }
        for ix in instr {
            let _ = self.append(ix)
            
        }
        _ = self.append("")
        return self
    }
    
    static public func +(this:CodeEmission, _ intr:String) -> CodeEmission {
        return this.append(intr)
    }
    
    static public func +=(this:CodeEmission, _ intr:[String]) -> CodeEmission {
        for instr in intr {
            let _ = this.append(instr)
            
        }
        return this
    }
}



public class CodeWriter {
    
    
    typealias Emitter = (VMExpression)-> CodeEmission;
    lazy var emitters = [String:Emitter]()
    let fileName:String
    let tempOffset:Int = 5
    var memMap:[String:String]
    
    init(fileName:String) {
        self.fileName = fileName
        self.memMap =  [
            "local" : "LCL",
            "static" : "N/A",
            "this" : "THIS",
            "that" : "THAT",
            "temp" : "\(tempOffset)",
            "pointer" : "N/A",
            "argument" : "ARG",
            "constant" : "N/A"
        ]
        
    }
    
    
    func segmentName(for value:String) -> String{
        return memMap[value]!
    }
    
    
    
    public func initCode(expr:VMExpression) -> CodeEmission {
        let emission = CodeEmission(expr:expr)
        return emission
            // init local
            .append("@64")
            .append("D=A")
            .append("@LCL")
            .append("M=D")
            // init stack
            .append("@32")
            .append("D=A")
            .append("@SP")
            .append("M=D")
    }
    
    
    
    
    public func popCall(expr:VMExpression) -> CodeEmission {
        let seg = expr.arg0!
        let hackAddr = (self.segmentName(for: seg))
        let pos = expr.arg1!
        let emission = CodeEmission(expr:expr)
        
        
        if (seg == "static") {
            return emission
                .append(ary: decrementStack(), comment: "decrement stack")
                .append(ary: loadStack())
                .append("@\(self.fileName).\(pos)")
                .append("M=D")
        }
        return emission
            //store the address of the target segement
            .append(ary: setAddr(to: hackAddr, offset: Int(pos)!), comment: "GOTO \(hackAddr) offset \(pos)")
            .append("D=A")
            .append("@\(hackAddr).REG", comment: "Store address in staging memory area")
            .append("M=D")
            //decrement the stack and store in D
            .append(ary: decrementStack(), comment: "decrement stack")
            .append(ary: loadStack(), comment: "loaded stack to D")
            //navigate to stored address and set form D
            .append("@\(hackAddr).REG",comment: "get address from register")
            .append("A=M")
            .append("M=D", comment: "store stack value in address")
        
    }
    
    public func addCall(expr:VMExpression) ->  CodeEmission {
        let emission = CodeEmission(expr:expr)
        return emission
            .append(ary: decrementStack())
            .append(ary: loadStack())
            .append(ary: decrementStack())
            .append(ary: gotoStack())
            .append("M=D+M")
            .append(ary: incrementStack())
    }
    
    public func negCall(expr:VMExpression) ->  CodeEmission {
        let emission = CodeEmission(expr:expr)
        return emission
            .append(ary: decrementStack())
            .append(ary: gotoStack())
            .append("M=-M")
            .append(ary: incrementStack())
    }
    
    
    public func pushCall(expr:VMExpression) ->  CodeEmission {
        let seg = expr.arg0!
        let hackAddr = (self.segmentName(for: seg))
        let pos = expr.arg1!
        let emission = CodeEmission(expr:expr)
        switch seg {
        case "constant":
            _ = emission
                .append("@\(pos)", comment: "push constant \(pos)")
                .append("D=A")
        case "static":
            _ = emission
                .append("@\(self.fileName).\(pos)")
                .append("D=M")
        default:
            _ = emission
                .append(ary: setAddr(to: hackAddr, offset: Int(pos)!))
                .append("D=M")
        }
        return emission
            .append(ary: storeStack())
            .append(ary: incrementStack())
        
    }
    
    
    
}
