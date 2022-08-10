//
//  BaseTabbarController.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 10/08/2022.
//

import UIKit

class BaseTabbarController: BaseNavigationController {
    
    let type: TabbarItem
    
    public required init(type: TabbarItem, rootVC: UIViewController) {
        self.type = type
        super.init(rootViewController: rootVC)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

