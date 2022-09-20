//
//  CloudComputingViewController.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 19/09/2022.
//

import UIKit
import Combine

final class CloudComputingViewController: BaseViewController {
    
    private let cloudComputingView: CloudComputingView = {
        let view = CloudComputingView()
        return view
    }()
    
    private let titleLabel: Label = {
        let label = Label(style: .paragraphMedium)
        label.text = "PROJECTS"
        label.contentHuggingPriority(for: .vertical)
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
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    lazy var viewModel: ProjectsViewModel = {
        return ProjectsViewModel()
    }()
    
    private var environments: [Environment] = []
    
    let refreshControl = UIRefreshControl()
    private var isLoading = false
    @Published var hasModel: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePublisher()
        constructHierarchy()
        configureTableView()
        configureRefreshControl()
        
        cloudComputingView.keyTextField.text = "db3b9641-b897-4f17-bc20-690a7db1de1d"
        cloudComputingView.secretTextField.text = "0bedd876-c4ab-43c2-99e1-0522ab755fc2"
        
        if let _ = KeyChainManager.shared.getTokenOutDevice() {
            self.hasModel = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.isHidden = true
        if hasModel {
            loadData()
        }
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
        viewModel.getData(type: .outDevice) { [weak self] isFetched in
            guard let self = self else { return }
            self.tableView.hideAnimatedActivityIndicatorView()
            if isFetched {
                self.isLoading = false
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            } else {
                self.logOut()
            }
        }
        self.updateUI()
    }
    
    private func updateUI() {
        titleLabel.isHidden = !hasModel
        tableView.isHidden = !hasModel
        cloudComputingView.isHidden = hasModel
    }
    
    @objc func refresh(_ sender: AnyObject) {
        loadData()
    }
}

// MARK: - Configure Publisher
extension CloudComputingViewController {
    private func configurePublisher() {
        cloudComputingView.urlTextField.textPublisher
            .dropFirst()
            .sink { [weak self] value in
            guard let self = self else { return }
            self.presentEnvironment()
        }.store(in: &self.cancellable)
        
        cloudComputingView.keyTextField.textPublisher.sink { [weak self] value in
            guard let self = self else { return }
            guard !value.isEmpty else {
                self.cloudComputingView.submitButton.isEnabled = false
                return
            }
            self.validateCloundAuth()
        }.store(in: &self.cancellable)
        
        cloudComputingView.secretTextField.textPublisher.sink { [weak self] value in
            guard let self = self else { return }
            guard !value.isEmpty else {
                self.cloudComputingView.submitButton.isEnabled = false
                return
            }
            self.validateCloundAuth()
        }.store(in: &self.cancellable)
        
        cloudComputingView.environmentView.listView.$selectedIndex.sink { [weak self] index in
            guard let self = self else { return }
            self.environments = self.getURLEnvironments(index: index ?? 0)
            self.cloudComputingView.urlTextField.text = ""
        }.store(in: &self.cancellable)
        
        cloudComputingView.submitButton.tapPublisher.sink { [weak self] _ in
            guard let self = self else { return }
            self.view.endEditing(true)
            self.performLogin()
        }.store(in: &self.cancellable)
    }
    
    private func validateCloundAuth() {
        let hasURL = cloudComputingView.urlTextField.text != ""
        let hasKey = cloudComputingView.keyTextField.text != ""
        let hasSecretKey = cloudComputingView.secretTextField.text != ""
        let isEnable = hasURL && hasKey && hasSecretKey
        cloudComputingView.submitButton.isEnabled = isEnable
    }
    
    private func performLogin() {
        guard let apiKey = self.cloudComputingView.keyTextField.text,
              let apiSecret = self.cloudComputingView.secretTextField.text,
              let urlString = self.cloudComputingView.urlTextField.text else { return
        }
        self.displayAnimatedActivityIndicatorView()
        APIManager.shared(.outDevice).authorize(apiKey: apiKey, apiSecret: apiSecret, urlString: "https://" + urlString) { [weak self] (isSuccess, error) in
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
    
    func performLogOut() {
        let logoutAlert = UIAlertController(title: nil, message: "Are you sure want to logout?", preferredStyle: .alert)
        
        logoutAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] (action: UIAlertAction!) in
            self?.logOut()
        }))
        
        logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        present(logoutAlert, animated: true, completion: nil)
    }
    
    private func logOut() {
        KeyChainManager.shared.signOutUserOutDevice()
        self.hasModel = false
        self.updateUI()
    }
}

// MARK: Configure Views
extension CloudComputingViewController {
    
    private func constructHierarchy() {
        layoutCloudView()
        layoutTitleLabel()
        layoutTableView()
    }
    
    private func layoutTitleLabel() {
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(Dimension.Spacing.spacing32)
        }
    }
    
    private func layoutCloudView() {
        self.view.addSubview(cloudComputingView)
        cloudComputingView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
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
extension CloudComputingViewController: UITableViewDataSource {
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
extension CloudComputingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        if let projectVC = storyboard.instantiateViewController(withIdentifier: "ScenesVC") as? ScenesVC {
//            guard let project = viewModel.objects?[indexPath.row] else {
//                return
//            }
//            let viewModel = ScenesViewModel(project: project)
//            projectVC.apiType = .outDevice
//            projectVC.viewModel = viewModel
//            self.navigationController?.pushViewController(projectVC, animated: true)
//        }
        
        let scencesVC = ScenesViewController()
//        let navigation = BaseNavigationController(rootViewController: scencesVC)
        guard let project = viewModel.objects?[indexPath.row] else {
            return
        }
        let viewModel = ScenesViewModel(project: project)
        scencesVC.apiType = .outDevice
        scencesVC.viewModel = viewModel
        self.navigationController?.pushViewController(scencesVC, animated: true)
    }
}

extension CloudComputingViewController {
    
    private func presentEnvironment() {
        let environmentVC = ListEnvironmentViewController(items: environments)
        
        environmentVC.selectedItemsPublisher.sink { [weak self] items in
            guard let self = self else { return }
            self.environments = items
            self.updateSelectedIndex()
            self.dismiss(animated: true)
        }.store(in: &cancellable)
        
        environmentVC.modalTransitionStyle = .crossDissolve
        environmentVC.modalPresentationStyle = .overFullScreen
        self.present(environmentVC, animated: true)
    }
    
    private func generatedQAEnv() -> [Environment] {
        let items = [
            Environment(title: "gateway-qa-1.qa.alto-platform.ai/api", selected: false),
            Environment(title: "gateway-qa-2.qa.alto-platform.ai/api", selected: false),
            Environment(title: "gateway-qa-3.qa.alto-platform.ai/api", selected: false),
            Environment(title: "gateway-e2e.qa.alto-platform.ai/api", selected: false),
            Environment(title: "gateway-demo.qa.alto-platform.ai/api", selected: false),
            Environment(title: "gateway-demo.ca.qa.alto-platform.ai/api", selected: false),
            Environment(title: "gateway-demo.eu.qa.alto-platform.ai/api", selected: false)
        ]
        return items
    }
    
    private func generatedProductEnv() -> [Environment] {
        let items = [
            Environment(title: "app.alto-platform.ai/api", selected: false),
            Environment(title: "app.ca.alto-platform.ai/api", selected: false),
            Environment(title: "app.eu.alto-platform.ai/api", selected: false)
        ]
        return items
    }
    
    private func getURLEnvironments(index: Int) -> [Environment] {
        if index != 0 {
            return generatedProductEnv()
        }
        return generatedQAEnv()
    }
    
    private func updateSelectedIndex() {
        let items = self.environments.filter { item -> Bool in
            return item.selected
        }
        self.cloudComputingView.urlTextField.text = items.first?.title
    }
}
