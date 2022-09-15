//
//  ListEnvironmentViewController.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 15/09/2022.
//

import UIKit
import Combine

final class ListEnvironmentViewController: BaseViewController {
    
    let environmentListView: SingleChoiceView = {
        let view = SingleChoiceView()
        view.tableView.isScrollEnabled = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        constructHierarchy()
    }
}

// MARK: - Configure Views
extension ListEnvironmentViewController {
    
    private func constructHierarchy() {
        layoutEnvironmentView()
    }
    
    private func layoutEnvironmentView() {
        view.addSubview(environmentListView)
        environmentListView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
