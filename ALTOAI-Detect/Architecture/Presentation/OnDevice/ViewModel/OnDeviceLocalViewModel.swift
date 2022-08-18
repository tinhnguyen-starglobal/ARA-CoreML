//
//  OnDeviceLocalViewModel.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 10/08/2022.
//

import UIKit
import Combine

final class OnDeviceLocalViewModel: BaseViewModel {
    var useCase: OnDeviceLocalUseCasePort
    
    init(useCase: OnDeviceLocalUseCasePort = OnDeviceLocalUseCase()) {
        self.useCase = useCase
    }
}

extension OnDeviceLocalViewModel {
    
    func verifyUrl(urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
}
