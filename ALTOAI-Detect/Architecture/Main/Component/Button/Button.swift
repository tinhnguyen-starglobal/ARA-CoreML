//
//  Button.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 11/08/2022.
//

import UIKit

final class Button: UIButton {
    
    private let style: ButtonStyle
    private var customState: ButtonState

    override var isEnabled: Bool {
        didSet {
            self.isEnabled ? self.updateState(.normal) : self.updateState(.disabled)
        }
    }

    override var state: UIControl.State {
        return self.customState.getState()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.updateState(.highlighted)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.updateState(.normal)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.updateState(.normal)
    }

    override var intrinsicContentSize: CGSize {
        let preferHeight: CGFloat
        switch self.style {
        case .primaryMedium:
            preferHeight = Dimension.Button.height44
        case .primarySmall:
            preferHeight = Dimension.Button.height38
        }
        return CGSize(width: UIView.noIntrinsicMetric, height: preferHeight)
    }

    required init(style: ButtonStyle) {
        self.style = style
        self.customState = .normal
        super.init(frame: .zero)
        self.updateState(.normal)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateState(_ state: ButtonState) {
        self.customState = isEnabled ? state : .disabled
        self.backgroundColor = style.getDecorator(state: self.customState).backgroundColor
        self.setTitleColor(style.getDecorator(state: self.customState).titleColor, for: .normal)
        self.setTitleColor(style.getDecorator(state: self.customState).titleColor, for: .normal)
        self.titleLabel?.font = style.getDecorator(state: self.customState).font
        self.layer.borderWidth = style.getDecorator(state: self.customState).borderWidth
        self.layer.borderColor = style.getDecorator(state: self.customState).borderColor.cgColor
        self.layer.cornerRadius = style.getDecorator(state: self.customState).cornerRadius
    }
}

