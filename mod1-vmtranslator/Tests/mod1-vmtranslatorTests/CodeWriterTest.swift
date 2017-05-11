//
//  CodeWriterTest.swift
//  mod1-vmtranslator
//
//  Created by Julian Exenberger on 2017/05/06.
//
//

import XCTest
import XCTest
@testable import mod1_vmtranslator


class CodeWriterTest: XCTestCase {

    func testPopCall() throws {
        let writer = CodeWriter(fileName: "test")
        let push = writer.pushCall(expr: VMExpression(line:2,op:"push",arg0: "constant", arg1: "123"))
        let pop = writer.popCall(expr: VMExpression(line:3,op:"pop",arg0: "local", arg1: "3"))
        print(writer.initCode(expr: VMExpression(line:1,op:"init",arg0: "", arg1: "")).asString())
        print(push.asString())
        print(pop.asString())
        
    }
    
    func testPopCallStatic() throws {
        let writer = CodeWriter(fileName: "test")
        let push = writer.pushCall(expr: VMExpression(line:2,op:"push",arg0: "constant", arg1: "123"))
        let pop = writer.popCall(expr: VMExpression(line:3,op:"pop",arg0: "static", arg1: "3"))
        print(writer.initCode(expr: VMExpression(line:1,op:"init",arg0: "", arg1: "")).asString())
        print(push.asString())
        print(pop.asString())
        
    }
    
    func testPopCallTemp() throws {
        let writer = CodeWriter(fileName: "test")
        let push = writer.pushCall(expr: VMExpression(line:2,op:"push",arg0: "constant", arg1: "123"))
        let pop = writer.popCall(expr: VMExpression(line:3,op:"pop",arg0: "temp", arg1: "3"))
        print(writer.initCode(expr: VMExpression(line:1,op:"init",arg0: "", arg1: "")).asString())
        print(push.asString())
        print(pop.asString())
        
    }
    
    func testPushCall() throws {
        let writer = CodeWriter(fileName: "test")
        let code = writer.pushCall(expr: VMExpression(line:2,op:"push",arg0: "local", arg1: "3"))
        print(writer.initCode(expr: VMExpression(line:1,op:"init",arg0: "", arg1: "")).asString())
        print(code.asString())
        
    }
    
    func testPushCallStatic() throws {
        let writer = CodeWriter(fileName: "test")
        let code = writer.pushCall(expr: VMExpression(line:2,op:"push",arg0: "static", arg1: "3"))
        print(writer.initCode(expr: VMExpression(line:1,op:"init",arg0: "", arg1: "")).asString())
        print(writer.pushCall(expr: VMExpression(line:2,op:"push",arg0: "constant", arg1: "123")).asString())
        print(writer.popCall(expr: VMExpression(line:2,op:"pop",arg0: "static", arg1: "3")).asString())
        print(code.asString())
        
    }
    
    func testAddCall() throws {
        let writer = CodeWriter(fileName: "test")
        let code = writer.addCall(expr: VMExpression(line:2,op:"add",arg0: "", arg1: ""))
        print(writer.initCode(expr: VMExpression(line:1,op:"init",arg0: "", arg1: "")).asString())
        print(writer.pushCall(expr: VMExpression(line:2,op:"push",arg0: "constant", arg1: "10")).asString())
        print(writer.pushCall(expr: VMExpression(line:2,op:"push",arg0: "constant", arg1: "10")).asString())
        print(code.asString())
        
    }
    

    
    
    static var allTests = [
        ("testPopCall", testPopCall),
        ]

}
