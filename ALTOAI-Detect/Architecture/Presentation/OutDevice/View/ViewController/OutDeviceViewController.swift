//
//  OutDeviceViewController.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 10/08/2022.
//

import UIKit
import Combine
import SnapKit
import AVFoundation

final class OutDeviceViewController: BaseViewController, Bindable {
    
    private let segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Edge Computing", "Cloud Computing"])
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    private let urlTextField: TextFieldView = {
        let textfieldView = TextFieldView(style: .normal(), state: .normal)
        textfieldView.placeholder = "URL"
        return textfieldView
    }()
    
    private let submitButton: Button = {
        let button = Button(style: .primaryMedium)
        button.isEnabled = false
        button.setTitle("Start Computing", for: .normal)
        return button
    }()
    
    var viewModel: OutDeviceViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePublisher()
        constructHierarchy()
    }
    
    func bindViewModel() {
        
    }
}

// MARK: - Configure Publisher
extension OutDeviceViewController {
    private func configurePublisher() {
        urlTextField.textPublisher.sink { [weak self] value in
            guard let self = self else { return }
            guard !value.isEmpty else {
                self.submitButton.isEnabled = false
                return
            }
            self.submitButton.isEnabled = true
        }.store(in: &self.cancellable)
        
        submitButton.tapPublisher.sink { [weak self] _ in
            guard let self = self else { return }
            if self.viewModel.verifyUrl(urlString: self.urlTextField.text) {
                self.checkPermissions()
                self.presentCamera()
            } else {
                self.urlTextField.setState(.error(message: "Something went wrong, try to check URL"))
            }
        }.store(in: &self.cancellable)
        
        
    }
    
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
        if let cameraVC = storyboard.instantiateViewController(withIdentifier: "CameraVCID") as? CameraVC {
            cameraVC.modalPresentationStyle = .fullScreen
            self.present(cameraVC, animated: true, completion: nil)
        }
    }
}

// MARK: Configure Views
extension OutDeviceViewController {
    
    private func constructHierarchy() {
        configureNavigation()
        layoutSegmentControl()
        layoutURLTextField()
        layoutSubmitButton()
    }
    
    private func configureNavigation() {
        self.navigationItem.title = "Access"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func layoutSegmentControl() {
        self.view.addSubview(segmentControl)
        segmentControl.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(Dimension.Spacing.spacing32)
            make.leading.trailing.equalToSuperview().inset(Dimension.Spacing.spacing16)
        }
    }
    
    private func layoutURLTextField() {
        self.view.addSubview(urlTextField)
        urlTextField.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(Dimension.Spacing.spacing24)
            make.leading.trailing.equalToSuperview().inset(Dimension.Spacing.spacing16)
        }
    }
    
    private func layoutSubmitButton() {
        self.view.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(urlTextField.snp.bottom).offset(Dimension.Spacing.spacing24)
            make.leading.trailing.equalToSuperview().inset(Dimension.Spacing.spacing16)
        }
    }
}
