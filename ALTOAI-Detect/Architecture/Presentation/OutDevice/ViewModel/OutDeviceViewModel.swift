//
//  OutDeviceViewModel.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 11/08/2022.
//

import UIKit
import Combine

final class OutDeviceViewModel: BaseViewModel {
    var useCase: OutDeviceUseCasePort
    
    init(useCase: OutDeviceUseCasePort = OutDeviceUseCase()) {
        self.useCase = useCase
    }
}


