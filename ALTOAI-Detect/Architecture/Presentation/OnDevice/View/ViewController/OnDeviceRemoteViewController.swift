//
//  OnDeviceRemoteViewController.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 18/08/2022.
//

import UIKit

final class OnDeviceRemoteViewController: BaseViewController {
    
    private let remoteView: OnDeviceRemoteView = {
        let view = OnDeviceRemoteView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        constructHierarchy()
    }
}

// MARK: Configure Views
extension OnDeviceRemoteViewController {
    
    private func constructHierarchy() {
        layoutRemoteView()
    }
    
    private func layoutRemoteView() {
        self.view.addSubview(remoteView)
        remoteView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Dimension.Spacing.spacing24)
            make.leading.trailing.equalToSuperview()
        }
    }
}
