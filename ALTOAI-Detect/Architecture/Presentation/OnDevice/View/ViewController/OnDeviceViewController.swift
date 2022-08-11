//
//  OnDeviceViewController.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 10/08/2022.
//

import UIKit
import Combine

final class OnDeviceViewController: BaseViewController {
    
    private let segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["API", "Local"])
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    private let remoteView: OnDeviceRemoteView = {
        let view = OnDeviceRemoteView()
        return view
    }()
    
    private let localView: OnDeviceLocalView = {
        let view = OnDeviceLocalView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSegmentView()
        constructHierarchy()
    }
    
    private func configureSegmentView() {
        remoteView.isHidden = false
        localView.isHidden = true
        segmentControl.addTarget(self, action: #selector(changeSegmentType(_:)), for: .valueChanged)
    }
    
    @objc func changeSegmentType(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            self.remoteView.isHidden = false
            self.localView.isHidden = true
        case 1:
            self.remoteView.isHidden = true
            self.localView.isHidden = false
        default:
            break
        }
    }
}

// MARK: Configure Views
extension OnDeviceViewController {
    
    private func constructHierarchy() {
        configureNavigation()
        layoutSegmentControl()
        layoutRemoteView()
        layoutLocalView()
    }
    
    private func configureNavigation() {
        self.navigationItem.title = "Access"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func layoutSegmentControl() {
        self.view.addSubview(segmentControl)
        segmentControl.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(Dimension.Spacing.spacing32)
            make.leading.trailing.equalToSuperview().inset(Dimension.Spacing.spacing16)
        }
    }
    
    private func layoutRemoteView() {
        self.view.addSubview(remoteView)
        remoteView.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(Dimension.Spacing.spacing24)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func layoutLocalView() {
        self.view.addSubview(localView)
        localView.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(Dimension.Spacing.spacing24)
            make.leading.trailing.equalToSuperview()
        }
    }
}
