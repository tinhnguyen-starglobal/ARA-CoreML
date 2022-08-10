//
//  ButtonState.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 11/08/2022.
//

import UIKit

enum ButtonState {
    case normal
    case highlighted
    case disabled

    func getState() -> UIControl.State {
        switch self {
        case .disabled:
            return UIControl.State.disabled
        case .highlighted:
            return UIControl.State.highlighted
        case .normal:
            return UIControl.State.normal
        }
    }
}

