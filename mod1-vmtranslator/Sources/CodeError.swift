//
//  CodeError.swift
//  mod1-vmtranslator
//
//  Created by Julian Exenberger on 2017/04/27.
//
//

import Foundation

public enum CodeError: Error {
    case invalidToken(Int, String)
    case parseError(Int, String)
    case bug(String)
}
