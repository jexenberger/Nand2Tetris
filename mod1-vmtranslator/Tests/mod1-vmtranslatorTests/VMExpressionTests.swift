//
//  VMExpressionTests.swift
//  mod1-vmtranslator
//
//  Created by Julian Exenberger on 2017/04/27.
//
//

import Foundation
import XCTest
@testable import mod1_vmtranslator


class VMExpressionTests {
    func testFrom() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let line1 = "pop local 0"
        let expr = try VMExpression.from(line: line1, at: 1)
        XCTAssertNotNil(expr)
    }
    
    
    static var allTests = [
        ("testFrom", testFrom),
        ]
}
