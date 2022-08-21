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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePublisher()
        constructHierarchy()
        
        remoteView.keyTextField.text = "a6cec2e6-bdae-431f-b664-355c2ca31f27"
        remoteView.secretTextField.text = "ee2f5923-f086-4cdb-9593-17cfac9b5bb4"
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
                self?.presentProject()
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
}

// MARK: Configure Views
extension OnDeviceRemoteViewController {
    
    private func constructHierarchy() {
        layoutRemoteView()
    }
    
    private func layoutRemoteView() {
        self.view.addSubview(remoteView)
        remoteView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Dimension.Spacing.spacing24)
            make.leading.trailing.equalToSuperview()
        }
    }
}
