//
//  BaseView.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 10/08/2022.
//

import UIKit
import Combine

public class BaseView: UIView {
    
    var cancellableBag = Set<AnyCancellable>()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        backgroundColor = .white
    }
    
    deinit {
        debugPrint("\(type(of: self)) deinit⚡️")
    }
}
