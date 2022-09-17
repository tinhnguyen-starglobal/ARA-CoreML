//
//  EnvironmentView.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 12/09/2022.
//

import UIKit
import Combine

final class EnvironmentView: BaseView {
    
    private let titleLabel: Label = {
        let label = Label(style: .titleMedium)
        label.numberOfLines = 1
        label.text = "Choose URL sourse:"
        return label
    }()
    
    let listView: ListRadioButtonView = {
        let view = ListRadioButtonView()
        view.tableView.isScrollEnabled = false
        return view
    }()
    
    required init() {
        super.init(frame: .zero)
        constructHierarchy()
        listView.setData([EnvironmentType.qaServer.title, EnvironmentType.proServer.title])
        listView.setSelected(at: 0)
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
        self.addSubview(listView)
        listView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Dimension.Spacing.spacing8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(Dimension.Spacing.spacing16)
        }
    }
}
