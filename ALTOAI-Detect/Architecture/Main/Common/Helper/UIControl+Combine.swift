//
//  UIControl+Combine.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 11/08/2022.
//

import UIKit
import Combine

public extension UIControl {
    func controlEventPublisher(for events: UIControl.Event) -> AnyPublisher<Void, Never> {
        Publishers.ControlEvent(control: self, events: events).eraseToAnyPublisher()
    }
}
