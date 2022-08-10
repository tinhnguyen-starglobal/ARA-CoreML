//
//  UITextField+Extension.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 11/08/2022.
//

import UIKit
import Combine

public extension UITextField {
    /// A publisher emitting any text changes to a this text field.
    var textPublisher: AnyPublisher<String?, Never> {
        Publishers.ControlProperty(control: self, events: .defaultValueEvents, keyPath: \.text)
            .eraseToAnyPublisher()
    }

    var textDidEndEditPublisher: AnyPublisher<String?, Never> {
        Publishers.ControlProperty(control: self, events: .editingDidEnd, keyPath: \.text)
            .eraseToAnyPublisher()
    }

    /// A publisher emitting any attributed text changes to this text field.
    var attributedTextPublisher: AnyPublisher<NSAttributedString?, Never> {
        Publishers.ControlProperty(control: self, events: .defaultValueEvents, keyPath: \.attributedText)
            .eraseToAnyPublisher()
    }

    /// A publisher that emits whenever the user taps the return button and ends the editing on the text field.
    var returnPublisher: AnyPublisher<Void, Never> {
        controlEventPublisher(for: .editingDidEndOnExit)
    }
}

extension UIControl.Event {
    static var defaultValueEvents: UIControl.Event {
        return [.allEditingEvents, .valueChanged]
    }
}

