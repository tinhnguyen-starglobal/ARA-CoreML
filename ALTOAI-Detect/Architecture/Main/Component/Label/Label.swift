//
//  Label.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 20/08/2022.
//

import UIKit

class Label: UILabel {
    
    private let style: LabelStyle

    required init(style: LabelStyle) {
        self.style = style
        super.init(frame: .zero)
        self.configureView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureView() {
        self.font = self.style.decorator.font
        self.textColor = self.style.decorator.textColor
    }

    var intrinsicHeight: CGFloat {
        return self.font.lineHeight.rounded(.up)
    }

    var decorator: LabelDecorator {
        return self.style.decorator
    }
}
