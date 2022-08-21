//
//  OnDeviceRemoteViewController.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 18/08/2022.
//

import UIKit

final class OnDeviceRemoteViewController: BaseViewController {
    
    private let remoteView: OnDeviceRemoteView = {
        let view = OnDeviceRemoteView()
        return view
    }()
    
    private let titleLabel: Label = {
        let label = Label(style: .paragraphMedium)
        label.text = "PROJECTS"
        return label
    }()
    
    lazy var tableView: DynamicTableView = {
        let tableView = DynamicTableView(frame: .zero)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 10
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    lazy var viewModel: ProjectsViewModel = {
        return ProjectsViewModel()
    }()
    
    let refreshControl = UIRefreshControl()
    private var isLoading = false
    @Published var hasModel: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePublisher()
        constructHierarchy()
        configureTableView()
        configureRefreshControl()
        
        if let _ = KeyChainManager.shared.getToken() {
            if let _ = KeyChainManager.shared.getToken() {
                self.hasModel = true
            }
        }
        
        remoteView.keyTextField.text = "a6cec2e6-bdae-431f-b664-355c2ca31f27"
        remoteView.secretTextField.text = "ee2f5923-f086-4cdb-9593-17cfac9b5bb4"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    func loadData(animated: Bool = true) {
        self.tableView.displayAnimatedActivityIndicatorView()
        isLoading = true
        viewModel.getData { _ in
            self.isLoading = false
            self.refreshControl.endRefreshing()
            self.tableView.hideAnimatedActivityIndicatorView()
            self.tableView.reloadData()
        }
        
        titleLabel.isHidden = !hasModel
        tableView.isHidden = !hasModel
        remoteView.isHidden = hasModel
    }
    
    @objc func refresh(_ sender: AnyObject) {
        loadData()
    }
}

// MARK: - Configure Publisher
extension OnDeviceRemoteViewController {
    private func configurePublisher() {
        remoteView.keyTextField.textPublisher.sink { [weak self] value in
            guard let self = self else { return }
            guard !value.isEmpty else {
                self.remoteView.submitButton.isEnabled = false
                return
            }
            let isEnable = self.remoteView.secretTextField.text != ""
            self.remoteView.submitButton.isEnabled = isEnable
        }.store(in: &self.cancellable)
        
        remoteView.secretTextField.textPublisher.sink { [weak self] value in
            guard let self = self else { return }
            guard !value.isEmpty else {
                self.remoteView.submitButton.isEnabled = false
                return
            }
            let isEnable = self.remoteView.keyTextField.text != ""
            self.remoteView.submitButton.isEnabled = isEnable
        }.store(in: &self.cancellable)
        
        remoteView.submitButton.tapPublisher.sink { [weak self] _ in
            guard let self = self else { return }
            self.performLogin()
        }.store(in: &self.cancellable)

    }
    
    private func performLogin() {
        guard let apiKey = self.remoteView.keyTextField.text,
              let apiSecret = self.remoteView.secretTextField.text else { return
        }
        self.displayAnimatedActivityIndicatorView()
        APIManager.shared.authorize(apiKey: apiKey, apiSecret: apiSecret) { [weak self] (isSuccess, error) in
            self?.hideAnimatedActivityIndicatorView()
        
            if (isSuccess) {
                self?.hasModel = true
                self?.loadData()
            } else {
                var message = "Something is wrong. Please try again"
                if let error = error as? CustomError {
                    message = error.rawValue
                }
                
                let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true)
            }
        }
    }
    
    private func presentProject() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let projectVC = storyboard.instantiateViewController(withIdentifier: "ProjectsVC") as? ProjectsVC {
            self.navigationController?.pushViewController(projectVC, animated: true)
        }
    }
    
    func performLogOut() {
        let logoutAlert = UIAlertController(title: nil, message: "Are you sure want to logout?", preferredStyle: .alert)

        logoutAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] (action: UIAlertAction!) in
            KeyChainManager.shared.signOutUser()
            self?.hasModel = false
            self?.loadData()
        }))

        logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))

        present(logoutAlert, animated: true, completion: nil)
    }
}

// MARK: Configure Views
extension OnDeviceRemoteViewController {
    
    private func constructHierarchy() {
        layoutTitleLabel()
        layoutRemoteView()
        layoutTableView()
    }
    
    private func layoutTitleLabel() {
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(Dimension.Spacing.spacing32)
        }
    }
    
    private func layoutRemoteView() {
        self.view.addSubview(remoteView)
        remoteView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Dimension.Spacing.spacing24)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func layoutTableView() {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Dimension.Spacing.spacing4)
            make.leading.trailing.equalToSuperview().inset(Dimension.Spacing.spacing16)
        }
    }
}

// MARK: - UITableViewDataSource
extension OnDeviceRemoteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.objects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RemoteDeviceTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        if let object = viewModel.objects?[indexPath.row], let name = object.name {
            cell.configureData(title: name)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension OnDeviceRemoteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
