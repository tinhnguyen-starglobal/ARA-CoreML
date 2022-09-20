//
//  ExperimentRunViewController.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 20/09/2022.
//

import UIKit
import Combine

final class ExperimentRunViewController: BaseViewController {
    
    let refreshControl = UIRefreshControl()
    
    private let titleLabel: Label = {
        let label = Label(style: .paragraphMedium)
        label.text = "EXPERIMENT RUNS"
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
    
    lazy var viewModel: ExperimentRunViewModel = {
        return ExperimentRunViewModel()
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
        tableView.registerReusableCell(ExperimentTableViewCell.self)
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
extension ExperimentRunViewController {
    
    private func constructHierarchy() {
        configureNavigation()
        layoutTitleLabel()
        layoutTableView()
    }
    
    private func configureNavigation() {
        self.navigationItem.title = viewModel.experiment?.name ?? viewModel.experiment?.id
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
extension ExperimentRunViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.objects?.count ?? 0
        
        if count == 0 {
            self.tableView.setEmptyMessage(isLoading ? "" : "No available experiment runs")
        } else {
            self.tableView.restore()
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ExperimentTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        if let object = viewModel.objects?[indexPath.row] {
            cell.configureData(title: object.id)
            if let experimentId = viewModel.experiment?.id {
                viewModel.checkIfModelDownloaded(experimentId: experimentId, runId: object.id) { yolo in
                    cell.runButton.isEnabled = yolo != nil
                    cell.statusImageView.image =  UIImage(named:yolo != nil ? "ic_ready" : "ic_download")
                }
            }
        }

        return cell
    }
}

// MARK: - UITableViewDelegate
extension ExperimentRunViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if let objectId = viewModel.objects?[indexPath.row].id, let experimentId = viewModel.experiment?.id {
            return self.viewModel.checkIfModelDownloaded(experimentId: experimentId, runId: objectId)
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            if let object = viewModel.objects?[indexPath.row] {
                let alert = UIAlertController(title: "Delete download?", message: "Downloaded model will be deleted, you may download it again anytime", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                    self.viewModel.removeModel(runId: object.id)
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }))
                self.present(alert, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let object = viewModel.objects?[indexPath.row] {
            self.tableView.displayAnimatedActivityIndicatorView()
            viewModel.downloadModelIfNeeded(experimentRunId: object.id) { (yolo, errorString) in
                self.tableView.hideAnimatedActivityIndicatorView()
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
                if let yolo = yolo {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    if let cameraVC = storyboard.instantiateViewController(withIdentifier: "CameraVCID") as? CameraViewController {
                        cameraVC.yolo = yolo
                        cameraVC.inferenceType = .local
                        cameraVC.modalPresentationStyle = .fullScreen
                        self.present(cameraVC, animated: true, completion: nil)
                    }
                } else {
                    let alert = UIAlertController(title: nil, message: errorString, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    }
}
