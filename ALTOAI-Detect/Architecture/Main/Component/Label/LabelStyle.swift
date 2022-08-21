//
//  LabelStyle.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 20/08/2022.
//

import UIKit

enum LabelStyle {
    case titleLarge
    case titleMedium
    case paragraphMedium
    
    var decorator: LabelDecorator {
        switch self {
        case .titleLarge:
            return LabelDecorator(font: Constants.Font.titleLarge)
        case .titleMedium:
            return LabelDecorator(font: Constants.Font.titleMedium)
        case .paragraphMedium:
            return LabelDecorator(font: Constants.Font.paragraphMedium, textColor: .lightGray)
        }
    }
}
