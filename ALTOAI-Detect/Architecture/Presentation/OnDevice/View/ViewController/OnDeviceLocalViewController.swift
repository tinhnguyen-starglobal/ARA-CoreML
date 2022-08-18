//
//  OnDeviceLocalViewController.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 18/08/2022.
//

import UIKit
import AVFoundation
import ZIPFoundation

final class OnDeviceLocalViewController: BaseViewController {
    
    private let localView: OnDeviceLocalView = {
        let view = OnDeviceLocalView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePublisher()
        constructHierarchy()
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
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.zip], asCopy: true)
        picker.delegate = self
        picker.allowsMultipleSelection = false
        self.present(picker, animated: true)
    }
}

// MARK: Configure Views
extension OnDeviceLocalViewController {
    
    private func constructHierarchy() {
        layoutLocalView()
    }

    private func layoutLocalView() {
        self.view.addSubview(localView)
        localView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
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
//                self.loadData()
//                self.tableView.reloadData()
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
