//
//  RadioButtonStyle.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 12/09/2022.
//

import Foundation

enum RadioButtonStyle {
    case focused
    case unfocused

    func getDecoration(_ isSelected: Bool) -> RadioButtonDecorator {
        switch self {
        case .focused:
            return isSelected ? self.selectedOfFocused() : self.unselectedOfFocused()
        case .unfocused:
            return isSelected ? self.selectedOfUnfocused() : self.unselectedOfUnfocused()
        }
    }

    private func selectedOfFocused() -> RadioButtonDecorator {
        return RadioButtonDecorator(
            borderColor: Constant.Color.Neutral.fog,
            borderWidth: Dimension.RadioButton.focusedBorderWidth,
            centerCircleColor: Constant.Color.Neutral.fog
        )
    }

    private func unselectedOfFocused() -> RadioButtonDecorator {
        return RadioButtonDecorator(
            borderColor: Constant.Color.Neutral.fog,
            borderWidth: Dimension.RadioButton.focusedBorderWidth,
            centerCircleColor: Constant.Color.Neutral.fog
        )
    }

    private func selectedOfUnfocused() -> RadioButtonDecorator {
        return RadioButtonDecorator(
            borderColor: Constant.Color.Neutral.fog,
            centerCircleColor: Constant.Color.Neutral.fog
        )
    }

    private func unselectedOfUnfocused() -> RadioButtonDecorator {
        return RadioButtonDecorator()
    }
}

