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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        constructHierarchy()
    }
}

// MARK: Configure Views
extension OutDeviceViewController {
    
    private func constructHierarchy() {
        configureNavigation()
        layoutSegmentControl()
        layoutURLTextField()
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
}
