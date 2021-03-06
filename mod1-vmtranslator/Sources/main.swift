//
//  main.swift
//  mod1-vmtranslator
//
//  Created by Julian Exenberger on 2017/05/18.
//
//

import Foundation

if (CommandLine.arguments.count < 3) {
    print("Usage: mod1-vmtranslator [source vm code file] [target asm file]")
    exit(-1)
}

let src = CommandLine.arguments[1]
let target = CommandLine.arguments[2]
print("compiling '\(src)' to '\(target)'")

let writer = CodeWriter(fileName: target)
do {
    guard let parser = Parser(fromFile: src) else {
        print("unable to read and parse file \(src)")
        exit(-1)
    }
    
    _ = try writer.compile(using:parser)
    
} catch CodeError.invalidToken(let line, let error) {
    print("INVALID TOKEN::LINE: \(line) => \(error)")
} catch CodeError.invalidOp(let line, let error) {
    print("INVALID OP::LINE: \(line) => \(error)")
} catch CodeError.parseError(let line, let error) {
    print("PARSER ERROR::LINE: \(line) => \(error)")
} catch CodeError.bug(let error) {
    print("GENERAL ERROR::LINE:  \(error)")
} catch {
    print("UNKNOWN ERROR")
}
