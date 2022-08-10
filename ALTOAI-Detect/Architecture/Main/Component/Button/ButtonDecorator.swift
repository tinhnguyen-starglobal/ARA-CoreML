//
//  ButtonDecorator.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 11/08/2022.
//

import UIKit

struct ButtonDecorator {
    var backgroundColor: UIColor = Constant.Color.Primary.blue
    var titleColor: UIColor = Constant.Color.Neutral.white
    var cornerRadius: CGFloat = Dimension.cornerRadius
    var borderWidth: CGFloat = Dimension.Button.borderWidth1
    var borderColor: UIColor = Constant.Color.Neutral.fog
    var font = UIFont(name: "AvenirNext-Bold", size: 14)
}
