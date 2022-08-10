//
//  TabbarItem.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 10/08/2022.
//

import UIKit

enum TabbarItem: CaseIterable {
    
    case outDevice
    case onDevice
    
    var title: String {
        switch self {
        case .outDevice:
            return "tabbar_search"
        case .onDevice:
            return "tabbar_history"
        }
    }
    
    var iconActive: UIImage? {
        switch self {
        case .outDevice:
            return UIImage(named: "ic_search_active")
        case .onDevice:
            return UIImage(named: "ic_history_active")
        }
    }
    
    var iconDeactive: UIImage? {
        switch self {
        case .outDevice:
            return UIImage(named: "ic_search_deactive")
        case .onDevice:
            return UIImage(named: "ic_history_deactive")
        }
    }
    
    var viewController: BaseNavigationController {
        switch self {
        case .outDevice:
            let outDeviceVC = OutDeviceViewController()
            return BaseTabbarController(type: .outDevice, rootVC: outDeviceVC)
        case .onDevice:
            let onDeviceVC = OnDeviceViewController()
            return BaseTabbarController(type: .onDevice, rootVC: onDeviceVC)
        }
    }
}

