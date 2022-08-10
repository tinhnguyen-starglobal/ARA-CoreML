//
//  UIColor+Extension.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 10/08/2022.
//

import UIKit

extension UIColor {
    
    convenience init(hex: String) {
        self.init(hex: hex, alpha: 1.0)
    }

    private convenience init(hex3: Int, alpha: CGFloat) {
        self.init(red: CGFloat(((hex3 & 0xF00) >> 8).duplicate4bits()) / 255.0,
                  green: CGFloat(((hex3 & 0x0F0) >> 4).duplicate4bits()) / 255.0,
                  blue: CGFloat(((hex3 & 0x00F) >> 0).duplicate4bits()) / 255.0,
                  alpha: CGFloat(alpha))
    }

    private convenience init(hex6: Int, alpha: CGFloat) {
        self.init(red: CGFloat((hex6 & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((hex6 & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat((hex6 & 0x0000FF) >> 0) / 255.0, alpha: CGFloat(alpha))
    }

    convenience init(hex: String, alpha: CGFloat) {
        var hex = hex

        // Check for hash and remove the hash
        if hex.hasPrefix("#") {
            hex = String(hex[hex.index(after: hex.startIndex)...])
        }

        guard let hexVal = Int(hex, radix: 16) else {
            assertionFailure()
            self.init(red: 0, green: 0, blue: 0, alpha: 1)
            return
        }

        switch hex.count {
            case 3:
                self.init(hex3: hexVal, alpha: alpha)
            case 6:
                self.init(hex6: hexVal, alpha: alpha)
            default:
                assertionFailure()
            self.init(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
}

private extension Int {
    func duplicate4bits() -> Int {
        return (self << 4) + self
    }
}

