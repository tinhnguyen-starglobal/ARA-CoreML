//
//  OutDeviceEdgeUseCasePort.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 10/08/2022.
//

import Combine
import Foundation

protocol OutDeviceEdgeUseCasePort {
    func perform() -> AnyPublisher<Bool, Error>
}