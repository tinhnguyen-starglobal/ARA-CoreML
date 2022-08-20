//
//  LocalModelTableViewCell.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 20/08/2022.
//

import UIKit

final class LocalDeviceTableViewCell: BaseTableViewCell {
    
    private let containerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = Constant.Color.Background.background2
        return view
    }()
    
    private let titleLabel: Label = {
        let label = Label(style: .titleMedium)
        label.numberOfLines = 1
        return label
    }()
    
    private let playButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "ic_play"), for: .normal)
        return button
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
extension LocalDeviceTableViewCell {
    
    private func constructHierarchy() {
        layoutContainerView()
        layoutTitleLabel()
        layoutPlayButton()
    }
    
    private func layoutContainerView() {
        self.contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(Dimension.Spacing.spacing16)
        }
    }
    
    private func layoutTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Dimension.Spacing.spacing16)
            make.top.bottom.equalToSuperview().inset(Dimension.Spacing.spacing12)
        }
    }
    
    private func layoutPlayButton() {
        containerView.addSubview(playButton)
        playButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.trailing).offset(Dimension.Spacing.spacing8)
            make.trailing.equalToSuperview().inset(Dimension.Spacing.spacing12)
        }
    }
}
