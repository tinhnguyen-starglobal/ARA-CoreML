//
//  ExperimentsViewController.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 20/09/2022.
//

import UIKit
import Combine

final class ExperimentsViewController: BaseViewController {
    
    let refreshControl = UIRefreshControl()
    
    private let titleLabel: Label = {
        let label = Label(style: .paragraphMedium)
        label.text = "EXPERIMENTS"
        label.contentHuggingPriority(for: .vertical)
        return label
    }()
    
    lazy var tableView: DynamicTableView = {
        let tableView = DynamicTableView(frame: .zero)
        tableView.backgroundColor = .white
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 10
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    var isLoading = false
    
    lazy var viewModel: ExperimentsViewModel = {
        return ExperimentsViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        constructHierarchy()
        configureTableView()
        configureRefreshControl()
        loadData()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerReusableCell(RemoteDeviceTableViewCell.self)
    }
    
    private func configureRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        loadData()
    }
    
    func loadData(animated: Bool = true) {
        self.displayAnimatedActivityIndicatorView()
        isLoading = true
        viewModel.getData { _ in
            self.isLoading = false
            self.refreshControl.endRefreshing()
            self.hideAnimatedActivityIndicatorView()
            self.tableView.reloadData()
        }
    }
}

// MARK: Configure Views
extension ExperimentsViewController {
    
    private func constructHierarchy() {
        configureNavigation()
        layoutTitleLabel()
        layoutTableView()
    }
    
    private func configureNavigation() {
        self.navigationItem.title = viewModel.scene?.name
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func layoutTitleLabel() {
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(Dimension.Spacing.spacing20)
            make.leading.trailing.equalToSuperview().inset(Dimension.Spacing.spacing32)
        }
    }
    
    private func layoutTableView() {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Dimension.Spacing.spacing4)
            make.leading.trailing.equalToSuperview().inset(Dimension.Spacing.spacing16)
            make.bottom.lessThanOrEqualToSuperview().inset(Dimension.Spacing.spacing8)
        }
    }
}

// MARK: - UITableViewDataSource
extension ExperimentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.objects?.count ?? 0
        
        if count == 0 {
            self.tableView.setEmptyMessage(isLoading ? "" : "No available scenes")
        } else {
            self.tableView.restore()
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RemoteDeviceTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        if let object = viewModel.objects?[indexPath.row] {
            cell.configureData(title: object.name ?? object.id)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ExperimentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        if let experimentRunVC = storyboard.instantiateViewController(withIdentifier: "ExperimentRunVC") as? ExperimentRunVC {
//            guard let experiment = viewModel.objects?[indexPath.row] else {
//                return
//            }
//            let viewModel = ExperimentRunViewModel(experiment: experiment)
//            viewModel.apiType = self.viewModel.apiType
//            experimentRunVC.viewModel = viewModel
//            self.navigationController?.pushViewController(experimentRunVC, animated: true)
//        }
        
        let experimentRunVC = ExperimentRunViewController()
        guard let experiment = viewModel.objects?[indexPath.row] else {
            return
        }
        
        let viewModel = ExperimentRunViewModel(experiment: experiment)
        viewModel.apiType = self.viewModel.apiType
        experimentRunVC.viewModel = viewModel
        self.navigationController?.pushViewController(experimentRunVC, animated: true)
    }
}

