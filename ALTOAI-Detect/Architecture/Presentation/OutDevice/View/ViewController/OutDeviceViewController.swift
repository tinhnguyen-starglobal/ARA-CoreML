//
//  OutDeviceViewController.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 10/08/2022.
//

import UIKit
import Combine
import SnapKit

final class OutDeviceViewController: BaseViewController {
    
    private let segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Edge Computing", "Cloud Computing"])
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    private let urlTextField: TextFieldView = {
        let textfieldView = TextFieldView(style: .normal(), state: .normal)
        textfieldView.placeholder = "URL"
        return textfieldView
    }()
    
    private let submitButton: Button = {
        let button = Button(style: .primaryMedium)
        button.isEnabled = false
        button.setTitle("Start Computing", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePublisher()
        constructHierarchy()
    }
}

// MARK: - Configure Publisher
extension OutDeviceViewController {
    private func configurePublisher() {
        urlTextField.textPublisher.sink { [weak self] value in
            guard let self = self else { return }
            guard !value.isEmpty else {
                self.submitButton.isEnabled = false
                return
            }
            self.submitButton.isEnabled = true
        }.store(in: &self.cancellable)
    }
}

// MARK: Configure Views
extension OutDeviceViewController {
    
    private func constructHierarchy() {
        configureNavigation()
        layoutSegmentControl()
        layoutURLTextField()
        layoutSubmitButton()
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
    
    private func layoutURLTextField() {
        self.view.addSubview(urlTextField)
        urlTextField.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(Dimension.Spacing.spacing24)
            make.leading.trailing.equalToSuperview().inset(Dimension.Spacing.spacing16)
        }
    }
    
    private func layoutSubmitButton() {
        self.view.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(urlTextField.snp.bottom).offset(Dimension.Spacing.spacing24)
            make.leading.trailing.equalToSuperview().inset(Dimension.Spacing.spacing16)
        }
    }
}
