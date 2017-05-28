//
//  VMExpression.swift
//  mod1-vmtranslator
//
//  Created by Julian Exenberger on 2017/04/27.
//
//

import Foundation


    
    extension Collection where Indices.Iterator.Element == Index {
        
        /// Returns the element at the specified index iff it is within bounds, otherwise nil.
        subscript (safe index: Index) -> Generator.Element? {
            return indices.contains(index) ? self[index] : nil
        }
    }


public struct VMExpression {
    let line:Int
    let op:String
    let arg0:String?
    let arg1:String?
    
    
    static func from(line:String, at:Int) throws -> VMExpression {
        let cleanedLine = line.replacingOccurrences(of: "\t", with: " ").trimmingCharacters(in: CharacterSet.whitespaces)
        let components = cleanedLine.components(separatedBy: " ")
        if components.count == 0 {
            throw CodeError.invalidToken(at, "Invalid line syntax '\(line)'")
        }
        let op = components.first!
        let arg0 = components[safe: 1]
        let arg1 = components[safe: 2]
        return VMExpression(line:at, op:op, arg0:arg0, arg1:arg1)
    }
    
    func asString() -> String {
        let arg0 = self.arg0 != nil ? self.arg0! : ""
        let arg1 = self.arg1 != nil ? self.arg1! : ""
        return "\t\(op) \(arg0) \(arg1)"
    }
}
