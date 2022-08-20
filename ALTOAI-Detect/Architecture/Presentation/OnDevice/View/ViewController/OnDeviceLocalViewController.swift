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
        let tableView = DynamicTableView(frame: .zero, style: .grouped)
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
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
    }
    
    private func configureTableView() {
//        self.tableView = DynamicTableView(frame: self.tableView.frame, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerReusableCell(LocalDeviceTableViewCell.self)
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
            make.top.equalToSuperview().offset(-Dimension.Spacing.spacing16)
            make.leading.trailing.bottom.equalToSuperview()
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LocalDeviceTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configureData(title: "coreml_printerxxxxx")
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
