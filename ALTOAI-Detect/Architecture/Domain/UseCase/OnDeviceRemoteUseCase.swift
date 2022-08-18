//
//  OnDeviceRemoteUseCase.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 18/08/2022.
//

import Combine
import Foundation

final class OnDeviceRemoteUseCase: OnDeviceRemoteUseCasePort {
    
    func perform() -> AnyPublisher<Bool, Error> {
        Future<Bool, Error> { promise in
            promise(.success(true))
        }.eraseToAnyPublisher()
    }
}
