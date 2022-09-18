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
            return "Out Device"
        case .onDevice:
            return "On Device"
        }
    }
    
    var iconActive: UIImage? {
        switch self {
        case .outDevice:
            return UIImage(named: "ic_cloud_fill")
        case .onDevice:
            return UIImage(named: "ic_folder_fill")
        }
    }
    
    var iconDeactive: UIImage? {
        switch self {
        case .outDevice:
            return UIImage(named: "ic_cloud")
        case .onDevice:
            return UIImage(named: "ic_folder")
        }
    }
    
    var viewController: BaseNavigationController {
        switch self {
        case .outDevice:
            let outDeviceVC = OutDeviceViewController()
//            outDeviceVC.bindViewModel(to: OutDeviceViewModel())
            return BaseTabbarController(type: .outDevice, rootVC: outDeviceVC)
        case .onDevice:
            let onDeviceVC = OnDeviceViewController()
            return BaseTabbarController(type: .onDevice, rootVC: onDeviceVC)
        }
    }
}

