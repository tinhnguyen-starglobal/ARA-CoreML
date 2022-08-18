//
//  OnDeviceLocalUseCase.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 18/08/2022.
//

import Combine
import Foundation

final class OnDeviceLocalUseCase: OnDeviceLocalUseCasePort {
    
    func fetchYOLOFromFile() -> AnyPublisher<YOLO?, Never> {
        Future<YOLO?, Never> { promise in
            promise(.success(nil))
        }.eraseToAnyPublisher()
    }
    
//    func isContainModelAndJson
}
