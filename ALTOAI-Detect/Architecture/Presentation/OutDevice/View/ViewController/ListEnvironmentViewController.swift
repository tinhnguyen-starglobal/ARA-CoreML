//
//  ListEnvironmentViewController.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 15/09/2022.
//

import UIKit
import Combine

final class ListEnvironmentViewController: BaseViewController {
    
    private let contentView: UIView = {
        let view = UIView(frame: .zero)
        view.layer.cornerRadius = 16
        view.backgroundColor = .white
        return view
    }()
    
    private let indicatorView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 3
        return view
    }()
    
    let environmentListView: SingleChoiceView = {
        let view = SingleChoiceView()
        view.tableView.isScrollEnabled = false
        return view
    }()
    
    private(set) var environments: [Environment] = []
    
    init(items: [Environment]) {
        self.environments = items
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        constructHierarchy()
        environmentListView.setData(environments)
    }
    
    private func configureView() {
        view.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
    }
}

// MARK: - Configure Views
extension ListEnvironmentViewController {
    
    private func constructHierarchy() {
        layoutContentView()
        layoutIndicatorView()
        layoutEnvironmentView()
    }
    
    private func layoutContentView() {
        self.view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func layoutIndicatorView() {
        contentView.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { make in
            make.width.equalTo(40)
            make.height.equalTo(5)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(Dimension.Spacing.spacing8)
        }
    }
    
    private func layoutEnvironmentView() {
        contentView.addSubview(environmentListView)
        environmentListView.snp.makeConstraints { make in
            make.top.equalTo(indicatorView.snp.bottom).offset(Dimension.Spacing.spacing8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(Dimension.Spacing.spacing32)
        }
    }
}
