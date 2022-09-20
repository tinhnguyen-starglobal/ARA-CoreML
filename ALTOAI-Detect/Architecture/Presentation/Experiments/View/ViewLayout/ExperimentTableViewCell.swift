//
//  ExperimentTableViewCell.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 20/09/2022.
//

import UIKit

final class ExperimentTableViewCell: BaseTableViewCell {
    
    private let containerView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    private let titleLabel: Label = {
        let label = Label(style: .titleMedium)
        label.numberOfLines = 1
        return label
    }()
    
    let statusImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let runButton: UIButton = {
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
        runButton.setImage(UIImage(named: "ic_play"), for: .normal)
        runButton.setImage(UIImage(named: "ic_play_disable"), for: .disabled)
    }
    
    func configureData(title: String) {
        titleLabel.text = title
    }
    
    func startLoading() {
        statusImageView.image = nil
        statusImageView.displayAnimatedActivityIndicatorView()
    }
    
    func stopLoading() {
        statusImageView.image = UIImage(named: "ic_ready")
        statusImageView.hideAnimatedActivityIndicatorView()
    }
}

// MARK: - Configure Views
extension ExperimentTableViewCell {
    
    private func constructHierarchy() {
        layoutContainerView()
        layoutTitleLabel()
        layoutStatusImageView()
        layoutNextButton()
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
    
    private func layoutStatusImageView() {
        containerView.addSubview(statusImageView)
        statusImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
            make.leading.equalTo(titleLabel.snp.trailing).offset(Dimension.Spacing.spacing8)
        }
    }
    
    private func layoutNextButton() {
        containerView.addSubview(runButton)
        runButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
            make.trailing.equalToSuperview().inset(Dimension.Spacing.spacing8)
            make.leading.equalTo(statusImageView.snp.trailing).offset(Dimension.Spacing.spacing8)
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


