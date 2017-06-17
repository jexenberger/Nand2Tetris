//
//  CodeWriterTest.swift
//  mod1-vmtranslator
//
//  Created by Julian Exenberger on 2017/05/06.
//
//

import XCTest
import XCTest
@testable import mod2_vmtranslator


class CodeWriterTest: XCTestCase {
    
    var currentFile:String = "/Users/julianexenberger/Desktop/nand2tetris/tools/out.asm"
    var buffer = ""
    
    override func setUp() {
        buffer = ""
    }
    
    override func tearDown()  {
        do {
            try buffer.write(toFile: currentFile, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            XCTFail("unable to write out code")
        }
    }
    
    func testPopCall() throws {
        let writer = CodeWriter(fileName: "test")
        let push = writer.pushCall(expr: VMExpression(line:2,op:"push",arg0: "constant", arg1: "123"))
        let pop = writer.popCall(expr: VMExpression(line:3,op:"pop",arg0: "local", arg1: "3"))
        write(writer.initCode(expr: VMExpression(line:1,op:"init",arg0: "", arg1: "")).asString())
        write(push.asString())
        write(pop.asString())
        
    }
    
    func testPopCallStatic() throws {
        let writer = CodeWriter(fileName: "test")
        let push = writer.pushCall(expr: VMExpression(line:2,op:"push",arg0: "constant", arg1: "123"))
        let pop = writer.popCall(expr: VMExpression(line:3,op:"pop",arg0: "static", arg1: "3"))
        write(writer.initCode(expr: VMExpression(line:1,op:"init",arg0: "", arg1: "")).asString())
        write(push.asString())
        write(pop.asString())
        
    }
    
    func testPopCallTemp() throws {
        let writer = CodeWriter(fileName: "test")
        let push = writer.pushCall(expr: VMExpression(line:2,op:"push",arg0: "constant", arg1: "123"))
        let pop = writer.popCall(expr: VMExpression(line:3,op:"pop",arg0: "temp", arg1: "3"))
        write(writer.initCode(expr: VMExpression(line:1,op:"init",arg0: "", arg1: "")).asString())
        write(push.asString())
        write(pop.asString())
        
    }
    
    func testPushCall() throws {
        let writer = CodeWriter(fileName: "test")
        let code = writer.pushCall(expr: VMExpression(line:2,op:"push",arg0: "local", arg1: "3"))
        write(writer.initCode(expr: VMExpression(line:1,op:"init",arg0: "", arg1: "")).asString())
        write(code.asString())
        
    }
    
    func testPushCallStatic() throws {
        let writer = CodeWriter(fileName: "test")
        let code = writer.pushCall(expr: VMExpression(line:2,op:"push",arg0: "static", arg1: "3"))
        write(writer.initCode(expr: VMExpression(line:1,op:"init",arg0: "", arg1: "")).asString())
        write(writer.pushCall(expr: VMExpression(line:2,op:"push",arg0: "constant", arg1: "123")).asString())
        write(writer.popCall(expr: VMExpression(line:2,op:"pop",arg0: "static", arg1: "3")).asString())
        write(code.asString())
        
    }
    
    func testAddCall() throws {
        let writer = CodeWriter(fileName: "test")
        let code = writer.addCall(expr: VMExpression(line:2,op:"add",arg0: "", arg1: ""))
        write(writer.initCode(expr: VMExpression(line:1,op:"init",arg0: "", arg1: "")).asString())
        write(writer.pushCall(expr: VMExpression(line:2,op:"push",arg0: "constant", arg1: "10")).asString())
        write(writer.pushCall(expr: VMExpression(line:2,op:"push",arg0: "constant", arg1: "10")).asString())
        write(code.asString())
        
    }
    
    func testSubCall() throws {
        let writer = CodeWriter(fileName: "test")
        let code = writer.subCall(expr: VMExpression(line:2,op:"sub",arg0: "", arg1: ""))
        write(writer.initCode(expr: VMExpression(line:1,op:"init",arg0: "", arg1: "")).asString())
        write(writer.pushCall(expr: VMExpression(line:2,op:"push",arg0: "constant", arg1: "10")).asString())
        write(writer.pushCall(expr: VMExpression(line:2,op:"push",arg0: "constant", arg1: "9")).asString())
        write(code.asString())
        
    }
    
    func testEqCall() throws {
        let writer = CodeWriter(fileName: "test")
        let code = writer.eqCall(expr:  VMExpression(line:2,op:"eq",arg0: "", arg1: ""))
        write(writer.initCode(expr: VMExpression(line:1,op:"init",arg0: "", arg1: "")).asString())
        write(writer.pushCall(expr: VMExpression(line:2,op:"push",arg0: "constant", arg1: "10")).asString())
        write(writer.pushCall(expr: VMExpression(line:2,op:"push",arg0: "constant", arg1: "10")).asString())
        write(code.asString())
        
    }
    
    func testEqCallFalse() throws {
        let writer = CodeWriter(fileName: "test")
        let code = writer.eqCall(expr:  VMExpression(line:2,op:"eq",arg0: "", arg1: ""))
        write(writer.initCode(expr: VMExpression(line:1,op:"init",arg0: "", arg1: "")).asString())
        write(writer.pushCall(expr: VMExpression(line:2,op:"push",arg0: "constant", arg1: "10")).asString())
        write(writer.pushCall(expr: VMExpression(line:2,op:"push",arg0: "constant", arg1: "9")).asString())
        write(code.asString())
        
    }
    
    func testLtCall() throws {
        let writer = CodeWriter(fileName: "test")
        let code = writer.ltCall(expr:  VMExpression(line:2,op:"lt",arg0: "", arg1: ""))
        write(writer.initCode(expr: VMExpression(line:1,op:"init",arg0: "", arg1: "")).asString())
        write(writer.pushCall(expr: VMExpression(line:2,op:"push",arg0: "constant", arg1: "9")).asString())
        write(writer.pushCall(expr: VMExpression(line:2,op:"push",arg0: "constant", arg1: "10")).asString())
        write(code.asString())
        
    }
    
    func testLtCallFalse() throws {
        let writer = CodeWriter(fileName: "test")
        let code = writer.ltCall(expr:  VMExpression(line:2,op:"lt",arg0: "", arg1: ""))
        write(writer.initCode(expr: VMExpression(line:1,op:"init",arg0: "", arg1: "")).asString())
        write(writer.pushCall(expr: VMExpression(line:2,op:"push",arg0: "constant", arg1: "10")).asString())
        write(writer.pushCall(expr: VMExpression(line:2,op:"push",arg0: "constant", arg1: "9")).asString())
        write(code.asString())
        
    }
    
    
    func testGtCall() throws {
        let writer = CodeWriter(fileName: "test")
        let code = writer.gtCall(expr:  VMExpression(line:2,op:"lt",arg0: "", arg1: ""))
        write(writer.initCode(expr: VMExpression(line:1,op:"init",arg0: "", arg1: "")).asString())
        write(writer.pushCall(expr: VMExpression(line:2,op:"push",arg0: "constant", arg1: "10")).asString())
        write(writer.pushCall(expr: VMExpression(line:2,op:"push",arg0: "constant", arg1: "9")).asString())
        write(code.asString())
        
    }
    
    func testGtCallFalse() throws {
        let writer = CodeWriter(fileName: "test")
        let code = writer.gtCall(expr:  VMExpression(line:2,op:"lt",arg0: "", arg1: ""))
        write(writer.initCode(expr: VMExpression(line:1,op:"init",arg0: "", arg1: "")).asString())
        write(writer.pushCall(expr: VMExpression(line:2,op:"push",arg0: "constant", arg1: "9")).asString())
        write(writer.pushCall(expr: VMExpression(line:2,op:"push",arg0: "constant", arg1: "10")).asString())
        write(code.asString())
        
    }
    
    func testAndCall() throws {
        let writer = CodeWriter(fileName: "test")
        let code = writer.andCall(expr:  VMExpression(line:2,op:"and",arg0: "", arg1: ""))
        write(writer.initCode(expr: VMExpression(line:1,op:"init",arg0: "", arg1: "")).asString())
        write(writer.pushCall(expr: VMExpression(line:2,op:"push",arg0: "constant", arg1: "1")).asString())
        write(writer.pushCall(expr: VMExpression(line:2,op:"push",arg0: "constant", arg1: "1")).asString())
        write(code.asString())
        
    }
    
    func testAndCallNegate() throws {
        let writer = CodeWriter(fileName: "test")
        let code = writer.andCall(expr:  VMExpression(line:2,op:"and",arg0: "", arg1: ""))
        write(writer.initCode(expr: VMExpression(line:1,op:"init",arg0: "", arg1: "")).asString())
        write(writer.pushCall(expr: VMExpression(line:2,op:"push",arg0: "constant", arg1: "1")).asString())
        write(writer.pushCall(expr: VMExpression(line:2,op:"push",arg0: "constant", arg1: "0")).asString())
        write(code.asString())
        
    }
    
    func testOrCall() throws {
        let writer = CodeWriter(fileName: "test")
        let code = writer.orCall(expr:  VMExpression(line:2,op:"or",arg0: "", arg1: ""))
        write(writer.initCode(expr: VMExpression(line:1,op:"init",arg0: "", arg1: "")).asString())
        write(writer.pushCall(expr: VMExpression(line:2,op:"push",arg0: "constant", arg1: "1")).asString())
        write(writer.pushCall(expr: VMExpression(line:2,op:"push",arg0: "constant", arg1: "0")).asString())
        write(code.asString())
        
    }
    
    func testNegCall() throws {
        let writer = CodeWriter(fileName: "test")
        let code = writer.negCall(expr:  VMExpression(line:2,op:"neg",arg0: "", arg1: ""))
        write(writer.initCode(expr: VMExpression(line:1,op:"init",arg0: "", arg1: "")).asString())
        write(writer.pushCall(expr: VMExpression(line:2,op:"push",arg0: "constant", arg1: "8")).asString())
        write(code.asString())
        
    }
    
    func testNotCall() throws {
        let writer = CodeWriter(fileName: "test")
        let code = writer.notCall(expr:  VMExpression(line:2,op:"not",arg0: "", arg1: ""))
        write(writer.initCode(expr: VMExpression(line:1,op:"init",arg0: "", arg1: "")).asString())
        write(writer.pushCall(expr: VMExpression(line:2,op:"push",arg0: "constant", arg1: "1")).asString())
        write(code.asString())
        
    }
    
    func testNotCallFalse() throws {
        let writer = CodeWriter(fileName: "test")
        let code = writer.notCall(expr:  VMExpression(line:2,op:"not",arg0: "", arg1: ""))
        write(writer.initCode(expr: VMExpression(line:1,op:"init",arg0: "", arg1: "")).asString())
        write(writer.pushCall(expr: VMExpression(line:2,op:"push",arg0: "constant", arg1: "0")).asString())
        write(code.asString())
        
    }
    
    func testGenerate() throws {
        let writer = CodeWriter(fileName: "test")
        let expr = VMExpression(line:2,op:"not",arg0: "", arg1: "")
        write(try writer.generate(code: VMExpression(line:1,op:"init",arg0: "", arg1: "")).asString())
        write(try writer.generate(code: VMExpression(line:1,op:"push",arg0: "constant", arg1: "0")).asString())
        write(try writer.generate(code: expr).asString())
        
    }
    
    
    func testCompile() throws {
        let code = [
            "//push two constants onto the stack",
            "//add them together\n",
            "init",
            "push constant 8",
            "push constant 9",
            "call add 2",
            "function add 1",
            "add",
            "push constant 17",
            "eq",
            "return",
            "pop local 1"
        ]
        try code.joined(separator: "\n").write(toFile: "test.vm", atomically: true, encoding: String.Encoding.utf8)
        guard let parser = Parser(fromFile: "test.vm") else {
            throw CodeError.bug("this should have worked")
        }
        let writer = CodeWriter(fileName: "/tmp/test.asm")
        _ = try writer.compile(using: parser)
        print("code written!")
    }
    
    func testReallySimpleFunction() throws {
        let code = [
            "init",
            "call add 0",
            "pop local 0",
            "function add 0",
            "push constant 1",
            "push constant 1",
            "add",
            "return\n",
            ]
        try code.joined(separator: "\n").write(toFile: "reallySimpleFunction.vm", atomically: true, encoding: String.Encoding.utf8)
        guard let parser = Parser(fromFile: "reallySimpleFunction.vm") else {
            throw CodeError.bug("this should have worked")
        }
        let writer = CodeWriter(fileName: "/tmp/reallySimpleFunction.asm")
        _ = try writer.compile(using: parser)
        print("code written!")
    }
    
    
    func testSimpleFunction() throws {
        let code = [
            "init",
            "push constant 1",
            "call add 1",
            "pop local 0",
            "function add 1",
            "push constant 1",
            "pop local 0",
            "push local 0",
            "push argument 0",
            "add",
            "return\n",
            ]
        try code.joined(separator: "\n").write(toFile: "simpleFunction.vm", atomically: true, encoding: String.Encoding.utf8)
        guard let parser = Parser(fromFile: "simpleFunction.vm") else {
            throw CodeError.bug("this should have worked")
        }
        let writer = CodeWriter(fileName: "/tmp/simpleFunction.asm")
        _ = try writer.compile(using: parser)
        print("code written!")
    }
    

    
    func write(_ code:String) {
        print(code)
        buffer += "\n\(code)"
    }
    

    
    
    static var allTests = [
        ("testPopCall", testPopCall),
        ]

}
