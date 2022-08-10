//
//  ButtonStyle.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 11/08/2022.
//

import UIKit

enum ButtonStyle {
    case primaryMedium
    case primarySmall

    func getDecorator(state: ButtonState) -> ButtonDecorator {
        switch self {
        case .primaryMedium:
            return getPrimaryMediumDecorator(state: state)
        case .primarySmall:
            return getPrimarySmallDecorator(state: state)
        }
    }

    private func getPrimaryMediumDecorator(state: ButtonState) -> ButtonDecorator {
        switch state {
        case .normal:
            return ButtonDecorator(backgroundColor: Constant.Color.Primary.blue,
                                   titleColor: Constant.Color.Neutral.white,
                                   borderWidth: Dimension.Button.borderWidth0,
                                   borderColor: .clear,
                                   font: UIFont(name: "AvenirNext-Bold", size: 14))
        case .highlighted:
            return ButtonDecorator(backgroundColor: Constant.Color.Primary.blue,
                                   titleColor: Constant.Color.Neutral.white,
                                   borderWidth: Dimension.Button.borderWidth0,
                                   borderColor: .clear,
                                   font: UIFont(name: "AvenirNext-Bold", size: 14))
        case .disabled:
            return ButtonDecorator(backgroundColor: Constant.Color.Accent.blue,
                                   titleColor: Constant.Color.Neutral.white,
                                   borderWidth: Dimension.Button.borderWidth0,
                                   borderColor: .clear,
                                   font: UIFont(name: "AvenirNext-Bold", size: 14))
        }
    }

    private func getPrimarySmallDecorator(state: ButtonState) -> ButtonDecorator {
        switch state {
        case .normal:
            return ButtonDecorator(backgroundColor: Constant.Color.Primary.blue,
                                   titleColor: Constant.Color.Neutral.white,
                                   borderWidth: Dimension.Button.borderWidth0,
                                   borderColor: .clear,
                                   font: UIFont(name: "AvenirNext-Bold", size: 14))
        case .highlighted:
            return ButtonDecorator(backgroundColor: Constant.Color.Primary.blue,
                                   titleColor: Constant.Color.Neutral.white,
                                   borderWidth: Dimension.Button.borderWidth0,
                                   borderColor: .clear,
                                   font: UIFont(name: "AvenirNext-Bold", size: 14))
        case .disabled:
            return ButtonDecorator(backgroundColor: Constant.Color.Primary.blue,
                                   titleColor: Constant.Color.Neutral.white,
                                   borderWidth: Dimension.Button.borderWidth0,
                                   borderColor: .clear,
                                   font: UIFont(name: "AvenirNext-Bold", size: 14))
        }
    }
}

