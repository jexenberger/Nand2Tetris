//
//  Parser.swift
//  mod1-vmtranslator
//
//  Created by Julian Exenberger on 2017/04/27.
//
//

import Foundation


public class Parser {
    
    let sourceCode:[String]
    var currentLine:Int
    
    
    
    init?(fromFile fileName:String) {
        currentLine = -1
        do {
            let code = try String(contentsOfFile: fileName)
            self.sourceCode = code.components(separatedBy: CharacterSet.newlines)
        } catch {
            return nil
        }
    }
    
    public func isLineIgnorable() -> Bool {
        guard let line = sourceCode[safe: currentLine] else {
            return false
        }
        let cleanedLine = line.trimmingCharacters(in: CharacterSet.whitespaces)
        return cleanedLine == "" || cleanedLine.hasPrefix("//")
    }
    
    public func hasMoreCode() -> Bool {
        return currentLine+1 < sourceCode.count
    }
    
    
    public func advance() -> Bool {
        currentLine += 1        
        while  (isLineIgnorable()) {
            currentLine += 1
        }
        guard hasMoreCode() else {
            return false
        }
        return true
    }
    
    public func instruction() throws -> VMExpression {
        guard currentLine >= 0 else {
            throw CodeError.bug("unexpected Error, parser was never initialized call advance()")
        }
        return try VMExpression.from(line: sourceCode[currentLine], at: currentLine+1)
    }
    
    
}
