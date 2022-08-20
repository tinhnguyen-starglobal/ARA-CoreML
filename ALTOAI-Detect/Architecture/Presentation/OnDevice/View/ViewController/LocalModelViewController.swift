//
//  LocalModelViewController.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 18/08/2022.
//

import UIKit

final class LocalModelViewController: BaseViewController {
    
    private let localView: OnDeviceLocalView = {
        let view = OnDeviceLocalView()
        return view
    }()
    
    lazy var tableView: DynamicTableView = {
        let tableView = DynamicTableView(frame: .zero)
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        constructHierarchy()
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.registerReusableCell(SearchTableViewCell.self)
    }
}

// MARK: Configure Views
extension LocalModelViewController {
    
    private func constructHierarchy() {
        configureNavigation()
    }
    
    private func configureNavigation() {
        self.navigationItem.title = "Local Models"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }
    
    @objc private func addTapped() {
        print("Did press add button")
    }
}

// MARK: - UITableViewDelegate
extension LocalModelViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: - UITableViewDataSource
extension LocalModelViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

