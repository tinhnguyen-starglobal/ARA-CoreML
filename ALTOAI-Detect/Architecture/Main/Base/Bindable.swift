//
//  Bindable.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 11/08/2022.
//

import UIKit
import Combine

protocol CancelableBag {
    var cancellableBag: Set<AnyCancellable> { get set }
}

protocol Bindable: AnyObject {
    associatedtype ViewModelPort
    var viewModel: ViewModelPort! { get set }
    func bindViewModel()
}

extension Bindable where Self: UIViewController {
    func bindViewModel(to model: Self.ViewModelPort) {
        viewModel = model
        self.bindViewModel()
    }
}
