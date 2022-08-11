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
    
    private let edgeComputingView: EdgeComputingView = {
        let view = EdgeComputingView()
        return view
    }()
    
    private let cloudComputingView: CloudComputingView = {
        let view = CloudComputingView()
        return view
    }()
    
    var viewModel: OutDeviceViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSegmentView()
        configurePublisher()
        constructHierarchy()
    }
    
    private func configureSegmentView() {
        edgeComputingView.isHidden = false
        cloudComputingView.isHidden = true
        segmentControl.addTarget(self, action: #selector(changeSegmentType(_:)), for: .valueChanged)
    }
    
    func bindViewModel() {
        
    }
    
    @objc func changeSegmentType(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            self.edgeComputingView.isHidden = false
            self.cloudComputingView.isHidden = true
        case 1:
            self.edgeComputingView.isHidden = true
            self.cloudComputingView.isHidden = false
        default:
            break
        }
    }
}

// MARK: - Configure Publisher
extension OutDeviceViewController {
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
extension OutDeviceViewController {
    
    private func constructHierarchy() {
        configureNavigation()
        layoutSegmentControl()
        layoutEdgeComputingView()
        layoutCloudComputingView()
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
    
    private func layoutEdgeComputingView() {
        self.view.addSubview(edgeComputingView)
        edgeComputingView.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(Dimension.Spacing.spacing24)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func layoutCloudComputingView() {
        self.view.addSubview(cloudComputingView)
        cloudComputingView.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(Dimension.Spacing.spacing24)
            make.leading.trailing.equalToSuperview()
        }
    }
}

extension OutDeviceViewController {
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
