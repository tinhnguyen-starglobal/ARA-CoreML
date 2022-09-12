//
//  ListRadioButtonView.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 12/09/2022.
//

import UIKit
import Combine

final class ListRadioButtonView: BaseView {
    
    // MARK: - Define Components
    lazy var tableView: DynamicTableView = {
        let tableView = DynamicTableView(frame: .zero, style: .plain)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.registerReusableCell(RadioButtonTableViewCell.self)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    // MARK: - Define Variables
    @Published private(set) var selectedIndex: Int?
    private var disableIndex: Int?

    private(set) var data: [String] = []

    convenience init(data: [String]) {
        self.init(frame: .zero)
        self.data = data
        self.setupTableView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateTableView()
    }

    func setData(_ data: [String]) {
        self.data = data
        self.tableView.reloadData()
        self.updateTableView()
    }

    func setSelected(at index: Int) {
        self.tableView.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .none)
    }

    func setDisableAtIndex(at index: Int?) {
        guard let index = index else { return }
        self.disableIndex = index
    }
}

// MARK: - Setup Components

extension ListRadioButtonView {
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
extension ListRadioButtonView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RadioButtonTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.radioButtonWithLabel.configure(with: data[indexPath.row])
        cell.isUserInteractionEnabled = indexPath.row == disableIndex ? false : true
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ListRadioButtonView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
    }
}
