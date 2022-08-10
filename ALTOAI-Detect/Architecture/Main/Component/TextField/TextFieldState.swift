//
//  TextFieldState.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 11/08/2022.
//

import UIKit

enum TextFieldState {
    case normal
    case success
    case error(message: String, numberOfLines: Int = 0)
    case unready
}
