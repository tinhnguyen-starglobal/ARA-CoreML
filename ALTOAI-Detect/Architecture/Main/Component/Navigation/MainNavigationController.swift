//
//  MainNavigationController.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 10/08/2022.
//

import UIKit

final class MainNavigationController: BaseNavigationController {
    
    private let mainTabBarVC: MainTabBarController
    
    public required init(tabBarItems: [TabbarItem]) {
        self.mainTabBarVC = MainTabBarController(tabBarItems: tabBarItems)
        super.init(rootViewController: self.mainTabBarVC)
        self.setConfig()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.tintColor = .white
        self.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    private func setConfig() {
        //Config
    }
}

