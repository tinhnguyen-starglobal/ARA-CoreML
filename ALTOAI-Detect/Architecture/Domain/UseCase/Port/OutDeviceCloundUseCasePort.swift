//
//  OutDeviceCloundUseCasePort.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 10/08/2022.
//

import Combine
import Foundation

protocol OutDeviceCloundUseCasePort {
    func perform() -> AnyPublisher<Bool, Error>
}

