//
//  SingleChoiceView.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 15/09/2022.
//

import UIKit
import Combine

final class SingleChoiceView: BaseView {
    
    private(set) var environments: [Environment] = []
    
    lazy var tableView: DynamicTableView = {
        let tableView = DynamicTableView(frame: .zero, style: .plain)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.registerReusableCell(SingleChoiceTableViewCell.self)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateTableView()
    }
}

// MARK: - Configure data
extension SingleChoiceView {
    
}

// MARK: - Configure Views
extension SingleChoiceView {
    private func setupTableView() {
        self.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(self.tableView.contentSize.height)
        }
    }

    private func updateTableView() {
        self.addSubview(self.tableView)
        self.tableView.snp.remakeConstraints { remake in
            remake.edges.equalToSuperview()
            remake.height.equalTo(self.tableView.contentSize.height)
        }
    }
}

// MARK: - UITableViewDataSource
extension SingleChoiceView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.environments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SingleChoiceTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.fulFillData(data: environments[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SingleChoiceView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
