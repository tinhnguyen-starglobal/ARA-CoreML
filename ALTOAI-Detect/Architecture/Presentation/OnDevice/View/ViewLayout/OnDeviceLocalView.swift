//
//  OnDeviceLocalView.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 11/08/2022.
//

import UIKit
import SnapKit

final class OnDeviceLocalView: BaseView {
    
    let messageLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.textAlignment = .center
        label.font = UIFont(name: "AvenirNext-Regular", size: 16)
        label.text = "Start by adding zip file with model from local storage"
        return label
    }()
    
    let submitButton: Button = {
        let button = Button(style: .primaryMedium)
        button.setTitle("Browse files", for: .normal)
        return button
    }()
    
    required init() {
        super.init(frame: .zero)
        constructHierarchy()
    }
}

// MARK: - Configure Views
extension OnDeviceLocalView {
    
    private func constructHierarchy() {
        layoutMessageLabel()
        layoutSubmitButton()
    }
    
    private func layoutMessageLabel() {
        self.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Dimension.Spacing.spacing16)
            make.leading.trailing.equalToSuperview().inset(Dimension.Spacing.spacing16)
        }
    }
    
    private func layoutSubmitButton() {
        self.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(Dimension.Spacing.spacing24)
            make.leading.trailing.equalToSuperview().inset(Dimension.Spacing.spacing16)
            make.bottom.equalToSuperview().inset(Dimension.Spacing.spacing16)
        }
    }
}


