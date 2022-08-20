//
//  LabelDecorator.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 20/08/2022.
//

import UIKit

struct LabelDecorator {
    
    let font: UIFont
    let textColor: UIColor
    
    init(font: UIFont, textColor: UIColor = UIColor.black) {
        self.font = font
        self.textColor = textColor
    }
}
