//
//  RadioButtonTableViewCell.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 12/09/2022.
//

import UIKit

final class RadioButtonTableViewCell: UITableViewCell, Reusable {
    
    // MARK: - Define Components
    let radioButtonWithLabel: RadioButtonWithLabel = {
        let radionButton = RadioButtonWithLabel("", radioButtonStyle: .unfocused)
        return radionButton
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.radioButtonWithLabel.set(selected)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupUI()
    }

    private func setupUI() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.selectionStyle = .none
        self.setupRadioButtonWithLabel()
    }
}

extension RadioButtonTableViewCell {
    private func setupRadioButtonWithLabel() {
        self.contentView.addSubview(self.radioButtonWithLabel)
        self.radioButtonWithLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
