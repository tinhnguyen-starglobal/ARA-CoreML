//
//  OnDeviceLocalViewController.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 18/08/2022.
//

import UIKit

final class OnDeviceLocalViewController: BaseViewController {
    
    private let localView: OnDeviceLocalView = {
        let view = OnDeviceLocalView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        constructHierarchy()
    }
}

// MARK: Configure Views
extension OnDeviceLocalViewController {
    
    private func constructHierarchy() {
        layoutLocalView()
    }

    private func layoutLocalView() {
        self.view.addSubview(localView)
        localView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
}
