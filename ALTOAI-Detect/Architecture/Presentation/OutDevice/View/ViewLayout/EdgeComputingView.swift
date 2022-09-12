//
//  EdgeComputingView.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 10/08/2022.
//

import UIKit
import SnapKit

final class EdgeComputingView: BaseView {
    
    let urlTextField: TextFieldView = {
        let textfieldView = TextFieldView(style: .normal(), state: .normal)
        textfieldView.placeholder = "URL"
        return textfieldView
    }()
    
    let submitButton: Button = {
        let button = Button(style: .primaryMedium)
        button.isEnabled = false
        button.setTitle("Start Computing", for: .normal)
        return button
    }()
    
    required init() {
        super.init(frame: .zero)
        constructHierarchy()
    }
}

// MARK: - Configure Views
extension EdgeComputingView {
    
    private func constructHierarchy() {
        layoutURLTextField()
        layoutSubmitButton()
    }
    
    private func layoutURLTextField() {
        self.addSubview(urlTextField)
        urlTextField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(Dimension.Spacing.spacing16)
        }
    }
    
    private func layoutSubmitButton() {
        self.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(urlTextField.snp.bottom).offset(Dimension.Spacing.spacing24)
            make.leading.trailing.equalToSuperview().inset(Dimension.Spacing.spacing16)
            make.bottom.equalToSuperview().inset(Dimension.Spacing.spacing16)
        }
    }
}

