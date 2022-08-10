//
//  Defaultable.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 11/08/2022.
//

import UIKit

protocol Defaultable {
    static var defaultValue: Self { get }
}

extension Bool: Defaultable {
    static var defaultValue: Bool { return false }
}

extension Int: Defaultable {
    static var defaultValue: Int { return 0 }

    func timeResend() -> String {
        return self < 10 ? "0\(self)" : "\(self)"
    }
}

extension Float: Defaultable {
    static var defaultValue: Float { return 0.0 }
}

extension CGFloat: Defaultable {
    static var defaultValue: CGFloat { return 0.0 }
}

extension String: Defaultable {
    static var defaultValue: String { return "" }
}

extension Double: Defaultable {
    static var defaultValue: Double { return 0.0 }
}

extension Array: Defaultable {
    static var defaultValue: [Element] { return [] }
}

extension Dictionary: Defaultable {
    static var defaultValue: [Key: Value] { return [:] }
}

extension Optional where Wrapped: Defaultable {
    func unwrapValue(_ value: Wrapped = Wrapped.defaultValue) -> Wrapped {
        return self ?? value
    }
}


