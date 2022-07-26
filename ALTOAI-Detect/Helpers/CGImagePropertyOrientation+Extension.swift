//
//  CGImagePropertyOrientation+Extension.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 26/07/2022.
//

import UIKit

extension CGImagePropertyOrientation {
    init(_ orientation: UIDeviceOrientation) {
        switch orientation {
        case .landscapeRight: self = .left
        case .landscapeLeft: self = .right
        case .portrait: self = .down
        case .portraitUpsideDown: self = .up
        default: self = .up
        }
    }
}
