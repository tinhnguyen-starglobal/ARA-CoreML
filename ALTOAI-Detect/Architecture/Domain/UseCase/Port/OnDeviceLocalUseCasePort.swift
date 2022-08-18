//
//  OnDeviceLocalUseCasePort.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 18/08/2022.
//

import Combine
import Foundation

protocol OnDeviceLocalUseCasePort {
    func fetchYOLOFromFile() -> AnyPublisher<YOLO?, Never>
}
