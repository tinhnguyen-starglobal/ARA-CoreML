//
//  OutDeviceViewController.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 10/08/2022.
//

import UIKit
import Combine

final class OutDeviceViewController: BaseViewController {
    
    private let segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Edge Computing", "Cloud Computing"])
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
    
    private lazy var edgeViewController: EdgeComputingViewController = {
        let viewController = EdgeComputingViewController()
        viewController.bindViewModel(to: OutDeviceViewModel())
        self.addViewController(child: viewController)
        return viewController
    }()
    
    private lazy var cloudViewController: CloudComputingViewController = {
        let viewController = CloudComputingViewController()
        self.addViewController(child: viewController)
        return viewController
    }()
    
    private(set) var isCloud = false
    private(set) var isEdge = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let _ = KeyChainManager.shared.getTokenOutDevice() {
            self.isCloud = true
        }
        configureSegmentView()
        configurePublisher()
        constructHierarchy()
    }
}

// MARK: - Configure Publisher
extension OutDeviceViewController {
    private func configurePublisher() {
        cloudViewController.$hasModel.sink { [weak self] isCloud in
            self?.isCloud = isCloud
            self?.configureSegmentState()
        }.store(in: &cancellable)
        
        logOutButton.tapPublisher.sink { [weak self] in
            self?.cloudViewController.performLogOut()
        }.store(in: &self.cancellable)
    }
}

// MARK: Configure SegmentControler
extension OutDeviceViewController {
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
            configureEdgeView()
        case 1:
            configureCloudView()
        default:
            break
        }
    }
    
    private func configureEdgeView() {
        addViewController(child: edgeViewController)
        removeViewController(child: cloudViewController)
        navigationItem.title = isCloud ? "Workspace" : "Access"
        navigationItem.rightBarButtonItem = isCloud ? UIBarButtonItem(customView: logOutButton) : nil
    }
    
    private func configureCloudView() {
        addViewController(child: cloudViewController)
        removeViewController(child: edgeViewController)
        navigationItem.title = "Access"
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
extension OutDeviceViewController {
    
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

