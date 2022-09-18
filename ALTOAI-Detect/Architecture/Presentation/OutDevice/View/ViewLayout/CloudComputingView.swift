//
//  CloudComputingView.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 11/08/2022.
//

import UIKit
import SnapKit

final class CloudComputingView: BaseView {
    
    let environmentView: EnvironmentView = {
        let view = EnvironmentView()
        return view
    }()
    
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
        textfieldView.title = "URL"
        textfieldView.textField.tintColor = .clear
        return textfieldView
    }()
    
    let iconView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "arrow-down")
        return imageView
    }()
    
    let keyTextField: TextFieldView = {
        let textfieldView = TextFieldView(style: .normal(), state: .normal)
        textfieldView.placeholder = "API key"
        textfieldView.title = "API key"
        return textfieldView
    }()
    
    let secretTextField: TextFieldView = {
        let textfieldView = TextFieldView(style: .normal(), state: .normal)
        textfieldView.placeholder = "API secret"
        textfieldView.title = "API secret"
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
        layoutEnvironmentView()
        layoutStackView()
        layoutIconView()
        layoutSubmitButton()
    }
    
    private func layoutEnvironmentView() {
        self.addSubview(environmentView)
        environmentView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(Dimension.Spacing.spacing16)
        }
    }
    
    private func layoutStackView() {
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(environmentView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(Dimension.Spacing.spacing16)
        }
        
        stackView.addArrangedSubview(urlTextField)
        stackView.addArrangedSubview(keyTextField)
        stackView.addArrangedSubview(secretTextField)
    }
    
    private func layoutIconView() {
        self.urlTextField.textField.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(Dimension.Spacing.spacing4)
        }
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
