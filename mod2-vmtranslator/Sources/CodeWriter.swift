//
//  CodeWriter.swift
//  mod1-vmtranslator
//
//  Created by Julian Exenberger on 2017/04/27.
//
//

import Foundation


public class CodeWriter {
    
    
    typealias Emitter = (VMExpression)-> CodeEmission;
    lazy var emitters = [String:Emitter]()
    let fileName:String
    let tempOffset:Int = 5
    var memMap:[String:String]
    static var idCounter:Int = 0
    
    init(fileName:String) {
        self.fileName = fileName
        self.memMap =  [
            "local" : "LCL",
            "static" : "STATIC",
            "this" : "THIS",
            "that" : "THAT",
            "temp" : "\(tempOffset)",
            "pointer" : "POINTER",
            "argument" : "ARG",
            "constant" : "N_A",
            "stack": "SP"
        ]
    }
    
     func getOpMap() -> [String:Emitter] {
        return [
            "push":pushCall,
            "pop":popCall,
            "add":addCall,
            "sub":subCall,
            "neg":negCall,
            "eq":eqCall,
            "gt":gtCall,
            "lt":ltCall,
            "and":andCall,
            "or":orCall,
            "not":bitwiseNotCall,
            "init":initCode,
            "label":callGotoLabel,
            "goto":callLabel,
            "if-goto":callIfGoto,
            "function":functionCall,
            "call": callCall,
            "return":returnCall
        ]
    }
    
    
    func generate(code expr:VMExpression) throws -> CodeEmission {
        guard let call = getOpMap()[expr.op] else {
            throw CodeError.invalidOp(expr.line, expr.op)
        }
        return call(expr)
    }
    
    func compile(using srcCode:Parser) throws -> String {
        var code = ""
        while srcCode.advance() {
           code += try generate(code: srcCode.instruction()).asString()
        }
        try code.write(toFile: self.fileName, atomically: true, encoding: String.Encoding.utf8)
        return code
    }
    
    
    func segmentName(for value:String) -> String{
        return memMap[value]!
    }
    
    
    
    public func initCode(expr:VMExpression) -> CodeEmission {
        let emission = CodeEmission(expr:expr)
        return emission
            // init local
            .append(ary: initPointer("@SP", at: 32))
            .append(ary: initPointer("@LCL", at: 64))
            .append(ary: initPointer("@THIS", at: 72))
            .append(ary: initPointer("@THAT", at: 73))
            .append(ary: initPointer("@ARG", at: 74))
    }
    
    
    public func nextId() -> Int {
        CodeWriter.idCounter += 1
        return CodeWriter.idCounter
    }
    
    public func generate(label:String) -> String {
        return "@\(label).\(CodeWriter.idCounter)"
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
        if (seg == "pointer") {
            let segment = (pos == "0") ? "THIS" : "THAT"
            return emission
                .append(ary: decrementStack(), comment: "decrement stack")
                .append(ary: loadStack())
                .append("@\(segment)")
                .append("M=D")
        }
        let nextId = self.nextId()
        return emission
            
            //store the address of the target segement
            .append(ary: setAddr(to: hackAddr, offset: Int(pos)!), comment: "GOTO \(hackAddr) offset \(pos)")
            .append("D=A")
            .append("@\(hackAddr).REG.\(nextId)", comment: "Store address in staging memory area")
            .append("M=D")
            //decrement the stack and store in D
            .append(ary: decrementStack(), comment: "decrement stack")
            .append(ary: loadStack(), comment: "loaded stack to D")
            //navigate to stored address and set form D
            .append("@\(hackAddr).REG.\(nextId)",comment: "get address from register")
            .append("A=M")
            .append("M=D", comment: "store stack value in address")
        
    }
    
    
    public func binaryOp(expr:VMExpression, op:String) ->  CodeEmission {
        let emission = CodeEmission(expr:expr)
        return emission
            .append(ary: decrementStack())
            .append(ary: loadStack())
            .append(ary: decrementStack())
            .append(ary: gotoStack())
            .append(op)
            .append(ary: gotoStack())
            .append("M=D")
            .append(ary: incrementStack())
    }
    
    
    public func addCall(expr:VMExpression) ->  CodeEmission {
        return binaryOp(expr: expr, op: "D=D+M")
    }

    public func subCall(expr:VMExpression) ->  CodeEmission {
        return binaryOp(expr: expr, op: "D=M-D")
    }
    
    public func andCall(expr:VMExpression) ->  CodeEmission {
        return binaryOp(expr: expr, op: "D=D&M")
    }

    public func orCall(expr:VMExpression) ->  CodeEmission {
        return binaryOp(expr: expr, op: "D=D|M")
    }
    
    
    public func unaryOp(expr:VMExpression, op:String) ->  CodeEmission {
        let emission = CodeEmission(expr:expr)
        return emission
            .append(ary: decrementStack())
            .append(ary: gotoStack())
            .append(op)
            .append(ary: incrementStack())
    }
    
    public func negCall(expr:VMExpression) ->  CodeEmission {
        return unaryOp(expr: expr, op: "M=-M")
    }
    
    public func bitwiseNotCall(expr:VMExpression) ->  CodeEmission {
        return unaryOp(expr: expr, op: "M=!M")
    }

    public func notCall(expr:VMExpression) ->  CodeEmission {
        return unaryJump(expr: expr, op: "", label: "NOT.VAL", jmpOp: "JLT")
    }
    
    
    
    func unique(variable:String) -> String {
        return "@\(variable).\(CodeWriter.idCounter)"
    }
    
    func unique(label:String) -> String {
        return "(\(label).\(CodeWriter.idCounter))"
    }
    
    
    public func eqCall(expr:VMExpression) ->  CodeEmission {
        _ = nextId()
        let emission = CodeEmission(expr:expr)
        return emission
            .append(ary: decrementStack())
            .append(ary: loadStack())
            .append(unique(variable: "XOR.A"))
            .append("M=D")
            .append(ary: decrementStack())
            .append(ary: loadStack())
            .append(unique(variable: "XOR.B"))
            .append("M=D")
            .append(ary: xor())
            .append(unique(variable: "XOR.RESULT"))
            .append("D=M")
            .append(ary: booleanOp(label: "EQ", operation: "JEQ"))
            .append(ary: gotoStack())
            .append("M=D")
            .append(ary: incrementStack())
    }
    
    public func binaryJump(expr:VMExpression, op:String, label:String, jmpOp:String) -> CodeEmission {
        _ = nextId()
        let emission = CodeEmission(expr:expr)
        return emission
            .append(ary: decrementStack())
            .append(ary: loadStack())
            .append(ary: decrementStack())
            .append(ary: gotoStack())
            .append(op)
            .append(ary: booleanOp(label: label, operation: jmpOp))
            .append(ary: gotoStack())
            .append("M=D")
            .append(ary: incrementStack())
    }
    
    
    public func unaryJump(expr:VMExpression, op:String, label:String, jmpOp:String) -> CodeEmission {
        _ = nextId()
        let emission = CodeEmission(expr:expr)
        return emission
            .append(ary: decrementStack())
            .append(ary: gotoStack())
            .append(op)
            .append(ary: booleanOp(label: label, operation: jmpOp))
            .append(ary: gotoStack())
            .append("M=D")
            .append(ary: incrementStack())
    }
    
    
    public func ltCall(expr:VMExpression) ->  CodeEmission {
        return binaryJump(expr: expr, op: "D=M-D", label: "LT", jmpOp: "JLT")
    }
    
    public func gtCall(expr:VMExpression) ->  CodeEmission {
        return binaryJump(expr: expr, op: "D=M-D", label: "GT", jmpOp: "JGT")
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
        case "pointer":
            let segment = (pos == "0") ? "THIS" : "THAT"
            _ = emission
                .append("@\(segment)")
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
    
    public func callLabel(expr:VMExpression) -> CodeEmission {
        let labelName = expr.arg0
        let emission = CodeEmission(expr: expr)
        return emission
                .append("@\(labelName!)")
                .append("0,JMP")
    }
    
    public func callIfGoto(expr:VMExpression) -> CodeEmission {
        let labelName = expr.arg0
        let emission = CodeEmission(expr: expr)
        return emission
                .append(ary: decrementStack())
                .append(ary: loadStack())
                .append("@\(labelName!)")
                .append("D,JGT")
    }

    
    public func callGotoLabel(expr:VMExpression) -> CodeEmission {
        let labelName = expr.arg0
        let emission = CodeEmission(expr: expr)
        return emission.append("(\(labelName!))")
    }

    public func functionCall(expr:VMExpression) -> CodeEmission {
        let emission = CodeEmission(expr: expr)
        let name = expr.arg0!
        let lclVars = Int(expr.arg1!)!
        _ = emission.append("(\(name))")
        for _ in 0..<lclVars {
            _ = emission.append(emission: pushCall(expr: VMExpression(line: expr.line,op:"push",arg0:"local",arg1:"0")))
        }
        return emission

    }
    
    public func returnCall(expr:VMExpression) -> CodeEmission {
        let emission = CodeEmission(expr: expr)
        let endFrame = "@Endframe.\(nextId())"
        let returnAddress = "@ReturnAddress.\(nextId())"
        return emission
                .append("@LCL //set endframe reference to local")
                .append("D=M")
                .append(endFrame)
                .append("M=D")
                .append("@5 //retrieve and store return address")
                .append("D=D-A")
                .append("A=D")
                .append("D=M")
                .append(returnAddress)
                .append("M=D")
                .append(emission: popCall(expr: VMExpression(line: expr.line,op:"pop",arg0:"argument",arg1:"0")))
                .append("@ARG //Recover SP to ARG + 1")
                .append("D=M+1")
                .append("@SP")
                .append("M=D")
                .append(ary: restoreFrom(endFrame: endFrame, pointer: "@THAT", amt: 1))
                .append(ary: restoreFrom(endFrame: endFrame, pointer: "@THIS", amt: 2))
                .append(ary: restoreFrom(endFrame: endFrame, pointer: "@ARG", amt: 3))
                .append(ary: restoreFrom(endFrame: endFrame, pointer: "@LCL", amt: 4))
                .append(returnAddress + "//Jump back to return address")
                .append("A=M")
                .append("0,JMP")
    }
    
    public func callCall(expr:VMExpression) -> CodeEmission {
        let emission = CodeEmission(expr: expr)
        let funcName = expr.arg0!
        let returnAddress = "\(funcName)$ret.\(nextId())"
        let nArgs = Int(expr.arg1!)!
        return emission
            .append("@\(returnAddress) //Return address for \(returnAddress)")
            .append("D=A")
            .append(ary: storeAndIncrementStack())
            .append(ary: storeAndIncrementPointers(pntrs: "@LCL","@ARG","@THIS","@THAT"))
            .append("@5 // set @ARG (by default set to 74)")
            .append("D=A")
            .append("@SP")
            .append("D=M-D")
            .append("@\(nArgs)")
            .append("D=D-A")
            .append("@ARG")
            .append("M=D //New ARG is set")
            .append("@SP")
            .append("D=M")
            .append("@LCL")
            .append("M=D")
            .append("@\(funcName)")
            .append("0,JMP")
            .append("(\(returnAddress))")
    }
    
    
    
}
