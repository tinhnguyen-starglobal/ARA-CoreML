//
//  BaseViewModel.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 11/08/2022.
//

import Combine
import Foundation

protocol CancellableBag {
    var cancellableBag: Set<AnyCancellable> { get set }
}

class BaseViewModel: CancellableBag {
    
    var cancellableBag = Set<AnyCancellable>()
    
    deinit {
        debugPrint("\(type(of: self)) deinit⚡️")
    }
}
