//
//  OutDeviceUseCase.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 10/08/2022.
//

import Combine
import Foundation

final class OutDeviceUseCase: OutDeviceUseCasePort {
    
    func perform() -> AnyPublisher<Bool, Error> {
        Future<Bool, Error> { promise in
            promise(.success(true))
        }.eraseToAnyPublisher()
    }
}
