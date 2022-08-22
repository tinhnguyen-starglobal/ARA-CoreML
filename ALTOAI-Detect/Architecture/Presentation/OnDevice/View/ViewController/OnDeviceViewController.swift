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
    
    private let logOutButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_logout"), for: .normal)
        return button
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
    
    private(set) var isRemote = false
    private(set) var isLocal = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let _ = KeyChainManager.shared.getToken() {
            self.isRemote = true
        }
        configurePublisher()
        configureSegmentView()
        constructHierarchy()
    }
}

// MARK: - Configure Publisher
extension OnDeviceViewController {
    private func configurePublisher() {
        localViewController.$hasModel.sink { [weak self] isLocal in
            self?.isLocal = isLocal
            self?.configureSegmentState()
        }.store(in: &cancellable)
        
        remoteViewController.$hasModel.sink { [weak self] isRemote in
            self?.isRemote = isRemote
            self?.configureSegmentState()
        }.store(in: &cancellable)
        
        logOutButton.tapPublisher.sink { [weak self] in
            self?.remoteViewController.performLogOut()
        }.store(in: &self.cancellable)
    }
}

// MARK: Configure SegmentControler
extension OnDeviceViewController {
    
    private func configureSegmentView() {
        configureSegmentState()
        segmentControl.addTarget(self, action: #selector(changeSegmentType(_:)), for: .valueChanged)
    }
    
    @objc func changeSegmentType(_ segmentedControl: UISegmentedControl) {
        configureSegmentState()
    }
    
    private func configureSegmentState() {
        let index = segmentControl.selectedSegmentIndex
        switch index {
        case 0:
            configureRemoteView()
        case 1:
            configureLocalView()
        default:
            break
        }
    }
    
    private func configureRemoteView() {
        addViewController(child: remoteViewController)
        removeViewController(child: localViewController)
        navigationItem.title = isRemote ? "Workspace" : "Access"
        navigationItem.rightBarButtonItem = isRemote ? UIBarButtonItem(customView: logOutButton) : nil
    }
    
    private func configureLocalView() {
        addViewController(child: localViewController)
        removeViewController(child: remoteViewController)
        navigationItem.title = isLocal ? "Local models" : "Access"
        navigationItem.rightBarButtonItem = isLocal ? UIBarButtonItem(barButtonSystemItem: .add,
                                                                      target: self,
                                                                      action: #selector(addTapped)) : nil
    }
    
    @objc private func addTapped() {
        self.localViewController.presentDocumentPicker()
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
        layoutBackButton()
        configureNavigation()
        layoutSegmentControl()
        layoutContainerView()
    }
    
    private func configureNavigation() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func layoutBackButton() {
        logOutButton.snp.makeConstraints { make in
            make.width.height.equalTo(36)
        }
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
