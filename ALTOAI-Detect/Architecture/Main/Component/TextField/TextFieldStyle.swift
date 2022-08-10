//
//  TextFieldStyle.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 11/08/2022.
//

import UIKit

enum TextFieldStyle {
    case normal(height: CGFloat = Dimension.TextFieldView.height)
    case search(height: CGFloat = Dimension.TextFieldView.height)
    
    func getDecoration(state: TextFieldState) -> TextFieldDecorator {
        switch self {
        case let .normal(height):
            return getNormalDecorator(state, height: height)
        case let .search(height):
            return getSearchDecorator(state, height: height)
        }
    }
}

// MARK: TextFieldStyle is Normal
extension TextFieldStyle {
    private func getNormalDecorator(_ state: TextFieldState, height: CGFloat) -> TextFieldDecorator {
        switch state {
        case .normal:
            return getNormalDecorator(height: height)
        case .success:
            return getSuccessDecorator(height: height)
        case .error:
            return getErrorDecorator(height: height)
        case .unready:
            return getUnreadyDecorator(height: height)
        }
    }
    
    private func getNormalDecorator(height: CGFloat) -> TextFieldDecorator {
        return TextFieldDecorator(textColor: Constant.Color.Neutral.text,
                                  placeholderColor: Constant.Color.Neutral.fog,
                                  unfocusedBorderColor: Constant.Color.Neutral.fog,
                                  focusedBorderColor: Constant.Color.Neutral.fog,
                                  height: height,
                                  font: UIFont(name: "AvenirNext-Regular", size: 16),
                                  titleFont: UIFont(name: "AvenirNext-Regular", size: 16),
                                  textErrorFont: UIFont(name: "AvenirNext-Regular", size: 12),
                                  descriptionFont: UIFont(name: "AvenirNext-Regular", size: 12),
                                  stateColor: Constant.Color.Neutral.text,
                                  rightViewImage: nil)
    }
    
    private func getSuccessDecorator(height: CGFloat) -> TextFieldDecorator {
        return TextFieldDecorator(textColor: Constant.Color.Neutral.text,
                                  placeholderColor: Constant.Color.Neutral.fog,
                                  unfocusedBorderColor: Constant.Color.Neutral.fog,
                                  focusedBorderColor: Constant.Color.Neutral.fog,
                                  height: height,
                                  font: UIFont(name: "AvenirNext-Regular", size: 16),
                                  titleFont: UIFont(name: "AvenirNext-Regular", size: 16),
                                  textErrorFont: UIFont(name: "AvenirNext-Regular", size: 12),
                                  descriptionFont: UIFont(name: "AvenirNext-Regular", size: 12),
                                  stateColor: Constant.Color.Neutral.text,
                                  rightViewImage: nil)
    }
    
    private func getErrorDecorator(height: CGFloat) -> TextFieldDecorator {
        return TextFieldDecorator(textColor: Constant.Color.Neutral.text,
                                  placeholderColor: Constant.Color.Neutral.fog,
                                  unfocusedBorderColor: Constant.Color.Neutral.fog,
                                  focusedBorderColor: Constant.Color.Neutral.fog,
                                  height: height,
                                  font: UIFont(name: "AvenirNext-Regular", size: 16),
                                  titleFont: UIFont(name: "AvenirNext-Regular", size: 16),
                                  textErrorFont: UIFont(name: "AvenirNext-Regular", size: 12),
                                  descriptionFont: UIFont(name: "AvenirNext-Regular", size: 12),
                                  stateColor: Constant.Color.Neutral.text,
                                  rightViewImage: UIImage(named: "ic_error"))
    }
    
    private func getUnreadyDecorator(height: CGFloat) -> TextFieldDecorator {
        return TextFieldDecorator(textColor: Constant.Color.Neutral.text,
                                  placeholderColor: Constant.Color.Neutral.fog,
                                  unfocusedBorderColor: Constant.Color.Neutral.fog,
                                  focusedBorderColor: Constant.Color.Neutral.fog,
                                  height: height,
                                  font: UIFont(name: "AvenirNext-Regular", size: 16),
                                  titleFont: UIFont(name: "AvenirNext-Regular", size: 16),
                                  textErrorFont: UIFont(name: "AvenirNext-Regular", size: 12),
                                  descriptionFont: UIFont(name: "AvenirNext-Regular", size: 12),
                                  stateColor: Constant.Color.Neutral.text,
                                  rightViewImage: nil)
    }
}

// MARK: TextFieldStyle for Search
extension TextFieldStyle {
    private func getSearchDecorator(_ state: TextFieldState, height: CGFloat) -> TextFieldDecorator {
        switch state {
        case .normal:
            return getNormalSearchDecorator(height: height)
        case .success:
            return getSuccessSearchDecorator(height: height)
        case .error:
            return getErrorSearchDecorator(height: height)
        case .unready:
            return getUnreadySearchDecorator(height: height)
        }
    }
    
    private func getNormalSearchDecorator(height: CGFloat) -> TextFieldDecorator {
        return TextFieldDecorator(textColor: Constant.Color.Neutral.text,
                                  placeholderColor: Constant.Color.Neutral.fog,
                                  unfocusedBorderColor: Constant.Color.Neutral.fog,
                                  focusedBorderColor: Constant.Color.Neutral.text,
                                  height: height,
                                  font: UIFont(name: "AvenirNext-Regular", size: 16),
                                  titleFont: UIFont(name: "AvenirNext-Regular", size: 16),
                                  textErrorFont: UIFont(name: "AvenirNext-Regular", size: 12),
                                  descriptionFont: UIFont(name: "AvenirNext-Regular", size: 12),
                                  stateColor: Constant.Color.Neutral.text,
                                  rightViewImage: nil)
    }
    
    private func getSuccessSearchDecorator(height: CGFloat) -> TextFieldDecorator {
        return TextFieldDecorator(textColor: Constant.Color.Neutral.text,
                                  placeholderColor: Constant.Color.Neutral.fog,
                                  unfocusedBorderColor: Constant.Color.Neutral.fog,
                                  focusedBorderColor: Constant.Color.Neutral.text,
                                  height: height,
                                  font: UIFont(name: "AvenirNext-Regular", size: 16),
                                  titleFont: UIFont(name: "AvenirNext-Regular", size: 16),
                                  textErrorFont: UIFont(name: "AvenirNext-Regular", size: 12),
                                  descriptionFont: UIFont(name: "AvenirNext-Regular", size: 12),
                                  stateColor: Constant.Color.Neutral.text,
                                  rightViewImage: nil)
    }
    
    private func getErrorSearchDecorator(height: CGFloat) -> TextFieldDecorator {
        return TextFieldDecorator(textColor: Constant.Color.Neutral.text,
                                  placeholderColor: Constant.Color.Neutral.fog,
                                  unfocusedBorderColor: Constant.Color.Neutral.fog,
                                  focusedBorderColor: Constant.Color.Neutral.text,
                                  height: height,
                                  font: UIFont(name: "AvenirNext-Regular", size: 16),
                                  titleFont: UIFont(name: "AvenirNext-Regular", size: 16),
                                  textErrorFont: UIFont(name: "AvenirNext-Regular", size: 12),
                                  descriptionFont: UIFont(name: "AvenirNext-Regular", size: 12),
                                  stateColor: Constant.Color.Neutral.text,
                                  rightViewImage: nil)
    }
    
    private func getUnreadySearchDecorator(height: CGFloat) -> TextFieldDecorator {
        return TextFieldDecorator(textColor: Constant.Color.Neutral.text,
                                  placeholderColor: Constant.Color.Neutral.fog,
                                  unfocusedBorderColor: Constant.Color.Neutral.fog,
                                  focusedBorderColor: Constant.Color.Neutral.text,
                                  height: height,
                                  font: UIFont(name: "AvenirNext-Regular", size: 16),
                                  titleFont: UIFont(name: "AvenirNext-Regular", size: 16),
                                  textErrorFont: UIFont(name: "AvenirNext-Regular", size: 12),
                                  descriptionFont: UIFont(name: "AvenirNext-Regular", size: 12),
                                  stateColor: Constant.Color.Neutral.text,
                                  rightViewImage: nil)
    }
}

