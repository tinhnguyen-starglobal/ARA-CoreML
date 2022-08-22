//
//  RemoteDeviceTableViewCell.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 22/08/2022.
//

import UIKit

final class RemoteDeviceTableViewCell: BaseTableViewCell {
    
    private let containerView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    private let titleLabel: Label = {
        let label = Label(style: .titleMedium)
        label.numberOfLines = 1
        return label
    }()
    
    private let numberLabel: Label = {
        let label = Label(style: .paragraphMedium)
        label.numberOfLines = 1
        return label
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "ic_next"), for: .normal)
        return button
    }()
    
    private let dividerLine: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = Constant.Color.Background.background2
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        constructHierarchy()
    }
    
    func configureData(title: String) {
        titleLabel.text = title
    }
}

// MARK: - Configure Views
extension RemoteDeviceTableViewCell {
    
    private func constructHierarchy() {
        layoutContainerView()
        layoutTitleLabel()
        layoutNextButton()
//        layoutNumberLabel()
        layoutDividerLine()
    }
    
    private func layoutContainerView() {
        self.contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func layoutTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Dimension.Spacing.spacing16)
            make.top.bottom.equalToSuperview().inset(Dimension.Spacing.spacing16)
        }
    }
    
    private func layoutNextButton() {
        containerView.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
            make.trailing.equalToSuperview().inset(Dimension.Spacing.spacing12)
            make.leading.equalTo(titleLabel.snp.trailing).offset(-Dimension.Spacing.spacing8)
        }
    }
    
    private func layoutNumberLabel() {
        containerView.addSubview(numberLabel)
        numberLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(nextButton.snp.leading).inset(Dimension.Spacing.spacing8)
        }
    }
    
    private func layoutDividerLine() {
        containerView.addSubview(dividerLine)
        dividerLine.snp.makeConstraints { make in
            make.height.equalTo(0.7)
            make.leading.trailing.equalToSuperview().inset(Dimension.Spacing.spacing16)
            make.bottom.equalToSuperview()
        }
    }
}

