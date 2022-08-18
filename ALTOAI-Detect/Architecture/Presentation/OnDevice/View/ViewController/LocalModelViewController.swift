//
//  LocalModelViewController.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 18/08/2022.
//

import UIKit

final class LocalModelViewController: BaseViewController {
    
    private let localView: OnDeviceLocalView = {
        let view = OnDeviceLocalView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        constructHierarchy()
    }
}

// MARK: Configure Views
extension LocalModelViewController {
    
    private func constructHierarchy() {
        configureNavigation()
    }
    
    private func configureNavigation() {
        self.navigationItem.title = "Local Models"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }
    
    @objc private func addTapped() {
        print("Did press add button")
    }
}
