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
    
    var environmentsPublisher: AnyPublisher<[Environment], Never> {
        environmentsSubject.eraseToAnyPublisher()
    }
    
    private let environmentsSubject = PassthroughSubject<[Environment], Never>()
    
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
    
    convenience init(data: [Environment]) {
        self.init(frame: .zero)
        self.environments = data
        self.setupTableView()
    }
}

// MARK: - Configure data
extension SingleChoiceView {
    func configureView(_ environments: [Environment]) {
        self.environments = environments
        self.tableView.reloadData()
        self.updateTableView()
    }
    
    func setSelected(at index: Int) {
        self.tableView.selectRow(at: IndexPath(row: index, section: 0),
                                 animated: true, scrollPosition: .none)
    }
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
        willSelectSingleItem(indexPath: indexPath)
        environmentsSubject.send(environments)
        tableView.reloadData()
    }
    
    func willSelectSingleItem(indexPath: IndexPath) {
        for index in 0..<self.environments.count {
            self.environments[index].selected = index == indexPath.row ? true : false
        }
    }
}
