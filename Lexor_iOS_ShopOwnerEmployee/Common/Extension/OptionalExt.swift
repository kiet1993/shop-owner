//
//  OptionalExt.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Ngoc Hien on 23/05/2021.
//

import Foundation

extension Optional  {
    func unwrapped(or defaultValue: Wrapped) -> Wrapped {
        if let value: Wrapped = self {
            return value
        }
        return defaultValue
    }
}

extension Optional where Wrapped == String {

    var content: String {
        switch self {
        case .some(let value):
            return String(describing: value)
        case _:
            return ""
        }
    }

    var orEmpty: String {
        if let value: String = self {
            return value
        }
        return ""
    }

    var isNilOrEmpty: Bool {
        switch self {
        case let .some(value): return value.isEmpty
        default: return true
        }
    }
}

