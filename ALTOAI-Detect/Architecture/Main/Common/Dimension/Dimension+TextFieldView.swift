//
//  Dimension+TextFieldView.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 11/08/2022.
//

import UIKit

extension Dimension {
    
    enum TextFieldView {
        
        static let height: CGFloat = 44
        static let unfocusedBorderWidth: CGFloat = 1
        static let focusedBorderWidth: CGFloat = 2

        enum SpaceValue {
            static let zero: CGFloat = 0
            static let three: CGFloat = 3
            static let four: CGFloat = 4
            static let eight: CGFloat = 8
            static let twelve: CGFloat = 12
        }

        enum FrameValue {
            static let zero: CGFloat = 0
            static let thirty: CGFloat = 30
            static let width28: CGFloat = 28
        }
    }
}
