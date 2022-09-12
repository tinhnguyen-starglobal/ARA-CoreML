//
//  EnvironmentView.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 12/09/2022.
//

import UIKit
import Combine

final class EnvironmentView: BaseView {
    
    enum EnvironmentType {
        case qaServer(title: String)
        case proServer(title: String)
    }
    
    private let titleLabel: Label = {
        let label = Label(style: .titleMedium)
        label.numberOfLines = 1
        label.text = "Choose URL sourse:"
        return label
    }()
    
    private let environmentListView: ListRadioButtonView = {
        let view = ListRadioButtonView()
        view.tableView.isScrollEnabled = false
        return view
    }()
    
    required init() {
        super.init(frame: .zero)
        constructHierarchy()
        environmentListView.setData(["QA servers", "Production servers"])
        environmentListView.setSelected(at: 0)
    }
}

// MARK: - Configure Views
extension EnvironmentView {
    
    private func constructHierarchy() {
        layoutTitleLabel()
        layoutEnvironmentListView()
    }
    
    private func layoutTitleLabel() {
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func layoutEnvironmentListView() {
        self.addSubview(environmentListView)
        environmentListView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Dimension.Spacing.spacing16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(Dimension.Spacing.spacing16)
        }
    }
}
