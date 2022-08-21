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
    
    @Published var hasModel: Bool = false
    
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
        hasModel = hasData
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
        tableView.deselectRow(at: indexPath, animated: true)
        if let object = viewModel.objects?[indexPath.row] {
            self.displayAnimatedActivityIndicatorView()
            viewModel.openModel(name: object) { (yolo, errorString) in
                self.hideAnimatedActivityIndicatorView()
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            if let object = viewModel.objects?[indexPath.row] {
                let alert = UIAlertController(title: "Delete download?", message: "Downloaded model will be deleted, you may download it again anytime", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                    self.viewModel.removeModel(name: object)
                    self.loadData()
                    self.tableView.reloadData()
                }))
                self.present(alert, animated: true)
            }
        }
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
                self.hasModel = true
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
