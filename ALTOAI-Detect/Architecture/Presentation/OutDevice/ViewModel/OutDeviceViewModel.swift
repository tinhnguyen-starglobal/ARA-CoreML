//
//  OutDeviceViewModel.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 11/08/2022.
//

import UIKit
import Combine

final class OutDeviceViewModel: BaseViewModel {
    var useCase: OutDeviceEdgeUseCasePort
    
    init(useCase: OutDeviceEdgeUseCasePort = OutDeviceEdgeUseCase()) {
        self.useCase = useCase
    }
}

extension OutDeviceViewModel {
    
    func verifyUrl(urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
}
