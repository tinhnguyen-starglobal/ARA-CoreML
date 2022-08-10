//
//  ViewModelPort.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 11/08/2022.
//

import Combine
import Foundation

protocol ViewModelPort {
    associatedtype Input
    associatedtype Output

    func transform(_ input: Input) -> Output
}
