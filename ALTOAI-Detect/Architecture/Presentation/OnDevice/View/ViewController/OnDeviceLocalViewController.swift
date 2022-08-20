//
//  OnDeviceLocalViewController.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 18/08/2022.
//

import UIKit
import Combine
import AVFoundation
import ZIPFoundation

final class OnDeviceLocalViewController: BaseViewController {
    
    private let localView: OnDeviceLocalView = {
        let view = OnDeviceLocalView()
        return view
    }()
    
    lazy var tableView: DynamicTableView = {
        let tableView = DynamicTableView(frame: .zero)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.clipsToBounds = true
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 10
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    lazy var viewModel: LocalViewModel = {
        return LocalViewModel()
    }()
    
    var hasModelPublisher: AnyPublisher<Bool, Never> {
        hasModelSubject.eraseToAnyPublisher()
    }
    
    private let hasModelSubject = PassthroughSubject<Bool, Never>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configurePublisher()
        constructHierarchy()
        loadData()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerReusableCell(LocalDeviceTableViewCell.self)
    }
    
    func loadData(animated: Bool = true) {
        displayAnimatedActivityIndicatorView()
        viewModel.getData()
        
        let hasData = viewModel.objects?.count ?? 0 > 0

        tableView.isHidden = !hasData
        localView.isHidden = hasData
        
        tableView.reloadData()

        hideAnimatedActivityIndicatorView()
    }
}

// MARK: - Configure Publisher
extension OnDeviceLocalViewController {
    private func configurePublisher() {
        localView.submitButton.tapPublisher.sink { [weak self] _ in
            self?.presentDocumentPicker()
        }.store(in: &self.cancellable)
        
        hasModelPublisher.sink { [weak self] hasModel in
            self?.tableView.isHidden = !hasModel
            self?.localView.isHidden = hasModel
        }.store(in: &self.cancellable)
    }
    
    func presentDocumentPicker() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.zip], asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        self.present(documentPicker, animated: true)
    }
}

// MARK: Configure Views
extension OnDeviceLocalViewController {
    
    private func constructHierarchy() {
        layoutLocalView()
        layoutTableView()
    }

    private func layoutLocalView() {
        self.view.addSubview(localView)
        localView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func layoutTableView() {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Dimension.Spacing.spacing16)
            make.leading.trailing.equalToSuperview().inset(Dimension.Spacing.spacing16)
        }
    }
}

// MARK: - UITableViewDelegate
extension OnDeviceLocalViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Did press on indexPath")
    }
}

// MARK: - UITableViewDataSource
extension OnDeviceLocalViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.objects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LocalDeviceTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        if let object = viewModel.objects?[indexPath.row] {
            cell.configureData(title: object)
        }
        
        return cell
    }
}

// MARK: UIDocumentPickerDelegate
extension OnDeviceLocalViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        self.displayAnimatedActivityIndicatorView()
        ModelOperationsHelper.getModelFromArchive(urls.first!, isLocal: true) { [weak self] yolo in
            guard let self = self else { return }
            self.hideAnimatedActivityIndicatorView()
            if let _ = yolo {
                self.hasModelSubject.send(true)
                self.loadData()
                self.tableView.reloadData()
            } else {
                self.showAlert()
            }
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: nil, message: "Your zip archive doesn't contain model and json file", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
