//
//  CloudComputingView.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 11/08/2022.
//

import UIKit
import SnapKit

final class CloudComputingView: BaseView {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = Dimension.Spacing.spacing16
        return stackView
    }()
    
    let urlTextField: TextFieldView = {
        let textfieldView = TextFieldView(style: .normal(), state: .normal)
        textfieldView.placeholder = "URL"
        return textfieldView
    }()
    
    let keyTextField: TextFieldView = {
        let textfieldView = TextFieldView(style: .normal(), state: .normal)
        textfieldView.placeholder = "API key"
        return textfieldView
    }()
    
    let secretTextField: TextFieldView = {
        let textfieldView = TextFieldView(style: .normal(), state: .normal)
        textfieldView.placeholder = "API secret"
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
extension CloudComputingView {
    
    private func constructHierarchy() {
        layoutStackView()
        layoutSubmitButton()
    }
    
    private func layoutStackView() {
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Dimension.Spacing.spacing24)
            make.leading.trailing.equalToSuperview().inset(Dimension.Spacing.spacing16)
        }
        
        stackView.addArrangedSubview(urlTextField)
        stackView.addArrangedSubview(keyTextField)
        stackView.addArrangedSubview(secretTextField)
    }
    
    private func layoutSubmitButton() {
        self.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(Dimension.Spacing.spacing24)
            make.leading.trailing.equalToSuperview().inset(Dimension.Spacing.spacing16)
            make.bottom.equalToSuperview().inset(Dimension.Spacing.spacing16)
        }
    }
}


