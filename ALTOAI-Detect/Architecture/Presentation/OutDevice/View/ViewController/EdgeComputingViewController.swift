//
//  EdgeComputingViewController.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 19/09/2022.
//

import UIKit
import Combine
import AVFoundation

final class EdgeComputingViewController: BaseViewController {
    
    private let edgeComputingView: EdgeComputingView = {
        let view = EdgeComputingView()
        return view
    }()
    
    var viewModel: OutDeviceViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePublisher()
        constructHierarchy()
    }
}

// MARK: - Configure Publisher
extension EdgeComputingViewController {
    private func configurePublisher() {
        edgeComputingView.urlTextField.textPublisher.sink { [weak self] value in
            guard let self = self else { return }
            guard !value.isEmpty else {
                self.edgeComputingView.submitButton.isEnabled = false
                return
            }
            self.edgeComputingView.submitButton.isEnabled = true
        }.store(in: &self.cancellable)
        
        edgeComputingView.submitButton.tapPublisher.sink { [weak self] _ in
            guard let self = self else { return }
            if self.viewModel.verifyUrl(urlString: self.edgeComputingView.urlTextField.text) {
                self.checkPermissions()
                self.presentCamera()
            } else {
                self.edgeComputingView.urlTextField.setState(.error(message: "Something went wrong, try to check URL"))
            }
        }.store(in: &self.cancellable)
    }
}

// MARK: Configure Views
extension EdgeComputingViewController {
    
    private func constructHierarchy() {
        layoutLocalView()
    }
    
    private func layoutLocalView() {
        self.view.addSubview(edgeComputingView)
        edgeComputingView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
}

extension EdgeComputingViewController {
    //MARK:- Permissions
    func checkPermissions() {
        let status =  AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            return
        case .denied:
            presentCameraSettings()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler:
                                            { (authorized) in
                if(!authorized){
                    print("Permission denied")
                }
            })
        case .restricted:
            print("Restricted, device owner must approve")
        @unknown default:
            print("Restricted, device owner must approve")
        }
    }
    
    func presentCameraSettings() {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Please allow camera assets",
                                                    message: "go to setttings and allow camera assets",
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alertController.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                        // Handle
                    })
                }
            })
            self.present(alertController, animated: true)
        }
    }
    
    private func presentCamera() {
        //TODO: Refactor CameraVC
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let cameraVC = storyboard.instantiateViewController(withIdentifier: "CameraVCID") as? CameraViewController {
            cameraVC.inferenceType = .edge
            cameraVC.edgeComputingUrl = self.edgeComputingView.urlTextField.text
            cameraVC.modalPresentationStyle = .fullScreen
            self.present(cameraVC, animated: true, completion: nil)
        }
    }
}
