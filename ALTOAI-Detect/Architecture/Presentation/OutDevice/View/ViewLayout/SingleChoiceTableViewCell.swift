//
//  SingleChoiceTableViewCell.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 15/09/2022.
//

import UIKit

final class SingleChoiceTableViewCell: BaseTableViewCell {
    
    var titleLabel: Label = {
        let label = Label(style: .titleMedium)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    var iconImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        return imageView
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    private func configureView() {
        constructHierarchy()
    }
}

// MARK: - Configure Views
extension SingleChoiceTableViewCell {
    
    private func constructHierarchy() {
        layoutTitleLabel()
        layoutImageView()
    }
    
    private func layoutTitleLabel() {
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Dimension.Spacing.spacing20)
            make.top.bottom.equalToSuperview().inset(Dimension.Spacing.spacing12)
        }
    }
    
    private func layoutImageView() {
        self.contentView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.trailing).offset(Dimension.Spacing.spacing4)
            make.trailing.equalToSuperview().inset(Dimension.Spacing.spacing16)
        }
    }
    
    func fulFillData(data: Environment) {
        titleLabel.text = data.title
        let imageName = data.selected ? "ic_checked" : ""
        iconImageView.image = UIImage(named: imageName)
    }
}
