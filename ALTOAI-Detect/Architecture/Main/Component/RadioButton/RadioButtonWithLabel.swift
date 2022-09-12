//
//  RadioButtonWithLabel.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 12/09/2022.
//

import UIKit
import Combine

final class RadioButtonWithLabel: UIView {
    
    private let radioButton: RadioButton
    
    private let titleLabel: Label = {
        let label = Label(style: .titleMedium)
        label.numberOfLines = 0
        return label
    }()
    
    private var rightStackView: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()

    private var rightView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let rightLabel: Label = {
        let label = Label(style: .titleMedium)
        label.numberOfLines = 1
        return label
    }()
    
    private var cancellable = Set<AnyCancellable>()
    @Published private(set) var isSelected: Bool = false
    
    required init(_ title: String, radioButtonStyle: RadioButtonStyle) {
        self.titleLabel.text = title
        self.radioButton = RadioButton(style: radioButtonStyle)
        super.init(frame: .zero)
        self.constructHierarchy()
    }

    required init?(coder: NSCoder) {
        self.radioButton = RadioButton(style: .unfocused)
        super.init(coder: coder)
        self.constructHierarchy()
    }
}

// MARK: Configure Views
extension RadioButtonWithLabel {
    
    private func constructHierarchy() {
        layoutRadioButton()
        layoutTitleLabel()
        layoutRightStackView()
        layoutRightLabel()
    }
    
    private func layoutRadioButton() {
        self.addSubview(self.radioButton)
        self.radioButton.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }

        self.handleRadioButtonAction()
    }

    private func layoutTitleLabel() {
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Dimension.Spacing.spacing8)
            make.leading.equalTo(self.radioButton.snp.trailing).offset(Dimension.Spacing.spacing12)
        }
    }

    private func layoutRightStackView() {
        self.addSubview(self.rightStackView)

        self.rightStackView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.top)
            make.trailing.equalToSuperview()
            make.leading.equalTo(self.titleLabel.snp.trailing)
        }
    }

    private func layoutRightLabel() {
        self.rightStackView.addArrangedSubview(self.rightView)
        self.rightView.addSubview(self.rightLabel)
        self.rightLabel.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalTo(Dimension.Spacing.spacing16)
        }
    }
}

// MARK: Action
extension RadioButtonWithLabel {
    // MARK: - Support Methods
    private func handleRadioButtonAction() {
        self.radioButton.$isSelected.sink { [weak self] value in
            guard let self = self else { return }
            self.isSelected = value
        }.store(in: &self.cancellable)
    }

    func addTapGesture() {
        self.gesture().sink { [weak self] _ in
            guard let self = self else { return }
            self.radioButton.setState(true)
        }.store(in: &self.cancellable)
    }

    func set(_ isSelect: Bool) {
        self.radioButton.setState(isSelect)
    }

    func configure(with leftTitle: String?, rightTitle: String? = nil) {
        self.titleLabel.text = leftTitle
        self.rightView.isHidden = rightTitle == nil
        self.rightLabel.text = rightTitle
    }
}
