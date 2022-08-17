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
    
    private let containerView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    private lazy var remoteViewController: OnDeviceRemoteViewController = {
        let viewController = OnDeviceRemoteViewController()
        self.addViewController(child: viewController)
        return viewController
    }()
    
    private lazy var localViewController: OnDeviceLocalViewController = {
        let viewController = OnDeviceLocalViewController()
        self.addViewController(child: viewController)
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSegmentView()
        constructHierarchy()
    }
    
    private func configureSegmentView() {
        configureSegmentState()
        segmentControl.addTarget(self, action: #selector(changeSegmentType(_:)), for: .valueChanged)
    }
    
    @objc func changeSegmentType(_ segmentedControl: UISegmentedControl) {
        configureSegmentState()
    }
}

// MARK: Configure SegmentControler
extension OnDeviceViewController {
    
    private func configureSegmentState() {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            removeViewController(child: localViewController)
            addViewController(child: remoteViewController)
        case 1:
            removeViewController(child: remoteViewController)
            addViewController(child: localViewController)
        default:
            break
        }
    }
    
    private func addViewController(child viewController: UIViewController) {
        addChild(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }
    
    private func removeViewController(child viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
}

// MARK: Configure Views
extension OnDeviceViewController {
    
    private func constructHierarchy() {
        configureNavigation()
        layoutSegmentControl()
        layoutContainerView()
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
    
    private func layoutContainerView() {
        self.view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(Dimension.Spacing.spacing24)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
