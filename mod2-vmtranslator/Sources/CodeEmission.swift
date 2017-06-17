//
//  CodeEmission.swift
//  mod2-vmtranslator
//
//  Created by Julian Exenberger on 2017/05/28.
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
        let comment = "\t// LINE \(expr.line) (\(expr.asString().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)))"
        var commentAdded = false
        let codeAry:[String] = instrs.map({(i,x) in
            var str = "\(i.hasPrefix("(") ? "" : "\t")\(i)" // + (x != nil ? "\t//\(x!)" : "")
            if !commentAdded {
                commentAdded = true
                str += comment
            }
            return str
        })
        return "\(codeAry.joined(separator: "\n"))\n"
    }
    
    public func append(_ instr:String, comment:String? = nil) -> CodeEmission {
        instrs.append((instr, comment))
        return self
    }
    
    public func append(emission:CodeEmission) -> CodeEmission {
        self.instrs.append(contentsOf: emission.instrs)
        return self
    }
    
    public func append(ary instr:[String], comment:String? = nil) -> CodeEmission {
        for ix in instr {
            let _ = (comment == nil) ?  self.append(ix) : self.append("\(ix)\t//\(comment!)")
            
        }
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
