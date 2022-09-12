//
//  UIView+Extension.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 12/09/2022.
//

import UIKit

extension UIView {
    func gesture(_ gestureType: GestureType = .tap()) -> GesturePublisher {
        .init(view: self, gestureType: gestureType)
    }
}
