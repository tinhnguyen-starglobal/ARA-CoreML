//
//  TextFieldDecorator.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 11/08/2022.
//

import UIKit

struct TextFieldDecorator {
    
    var textColor: UIColor = Constant.Color.Neutral.text
    var titleColor: UIColor = Constant.Color.Neutral.text
    var placeholderColor: UIColor = Constant.Color.Neutral.lightGray
    var unfocusedBorderColor: UIColor = Constant.Color.Neutral.fog
    var focusedBorderColor: UIColor = Constant.Color.Neutral.fog
    var descriptionColor: UIColor = Constant.Color.Neutral.text
    var backgroundColor: UIColor = Constant.Color.Neutral.white

    var unfocusedBorderWidth: CGFloat = Dimension.borderWidth
    var focusedBorderWidth: CGFloat = Dimension.borderWidth
    var cornerRadius: CGFloat = Dimension.cornerRadius
    var height: CGFloat = Dimension.TextFieldView.height

    var font = UIFont(name: "AvenirNext-Regular", size: 16)
    var titleFont = UIFont(name: "AvenirNext-Regular", size: 16)
    var textErrorFont = UIFont(name: "AvenirNext-Regular", size: 12)
    var descriptionFont = UIFont(name: "AvenirNext-Regular", size: 12)
    
    var stateColor: UIColor = Constant.Color.Neutral.text
    var rightViewImage: UIImage?
    var leftViewImage: UIImage?
}
