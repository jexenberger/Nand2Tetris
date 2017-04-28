//
//  ParserTest.swift
//  mod1-vmtranslator
//
//  Created by Julian Exenberger on 2017/04/27.
//
//

import XCTest
@testable import mod1_vmtranslator


class ParserTest: XCTestCase {

    func testInit() throws {
        let instrs:String = "push local 1\npop local 1"
        try instrs.write(toFile: "/tmp/sample.vm", atomically:true, encoding: String.Encoding.utf8)
        let parser = Parser(fromFile: "/tmp/sample.vm")
        XCTAssertNotNil(parser)
    }
    
    func testInstruction_Basic() throws {
        let instrs:String = "push local 1\npop temp 2"
        try instrs.write(toFile: "/tmp/sample.vm", atomically:true, encoding: String.Encoding.utf8)
        let parser = Parser(fromFile: "/tmp/sample.vm")
        let _ = parser?.advance()
        let instr0 = try parser?.instruction()
        XCTAssertEqual("push", instr0?.op)
        XCTAssertEqual("local", instr0?.arg0)
        XCTAssertEqual("1", instr0?.arg1)
        let _ = parser?.advance()
        let instr1 = try parser?.instruction()
        XCTAssertEqual("pop", instr1?.op)
        XCTAssertEqual("temp", instr1?.arg0)
        XCTAssertEqual("2", instr1?.arg1)
    }
    
    func testAdvance() throws {
        let instrs:String = "push local 1"
        try instrs.write(toFile: "/tmp/sample.vm", atomically:true, encoding: String.Encoding.utf8)
        let parser = Parser(fromFile: "/tmp/sample.vm")
        let _ = parser?.advance()
        let canAdvance = parser?.advance()
        XCTAssertFalse(canAdvance!)
    }

    
    func testAdvance_WhiteSpaceComments() throws {
        let instrs:String = "//start\npush local 1\n \npop temp 2"
        try instrs.write(toFile: "/tmp/sample.vm", atomically:true, encoding: String.Encoding.utf8)
        let parser = Parser(fromFile: "/tmp/sample.vm")
        let _ = parser?.advance()
        let _ = try parser?.instruction()
        let _ = parser?.advance()
        let _ = try parser?.instruction()
        let canAdvance = parser?.advance()
        XCTAssertFalse(canAdvance!)
    }
    
    
    
    
    
    static var allTests = [
        ("testInit", testInit),
        ("testInstruction_Basic", testInstruction_Basic),
        ("testAdvance", testAdvance),
        ("testAdvance_WhiteSpaceComments", testAdvance_WhiteSpaceComments),

    ]

}
