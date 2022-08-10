//
//  MainTabbarController.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 10/08/2022.
//

import UIKit

final class MainTabbarController: UITabBarController {
    
    private var tabBarItems: [TabbarItem]
    
    public required init(tabBarItems: [TabbarItem]) {
        self.tabBarItems = tabBarItems
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configResource()
        setupTabBarItem()
        setupTransparentForTabBar()
    }
    
    private func configResource() {
        self.viewControllers = tabBarItems.compactMap { $0.viewController }
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: Constant.Color.Secondary.gray,
             NSAttributedString.Key.font: UIFont(name: "AvenirNext-Regular", size: 12)!], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: Constant.Color.Primary.blue,
             NSAttributedString.Key.font: UIFont(name: "AvenirNext-Regular", size: 12)!],
                                                         for: .selected)

        self.tabBar.layer.masksToBounds = true
        self.tabBar.barStyle = .black
        self.tabBar.barTintColor = .white
        self.tabBar.tintColor = UIColor.orange

        self.tabBar.layer.shadowColor = UIColor.white.withAlphaComponent(1).cgColor
        self.tabBar.layer.shadowOffset = Dimension.Shadow.shadowOffset
        self.tabBar.layer.shadowRadius = Dimension.Shadow.shadowRadius
        self.tabBar.layer.shadowOpacity = Dimension.Shadow.shadowOpacity
        self.tabBar.layer.masksToBounds = false
    }
    
    @objc func setupTabBarItem() {
        guard let viewControllers = self.viewControllers else { return }
        for index in 0 ..< viewControllers.count {
            viewControllers[index].tabBarItem.selectedImage = tabBarItems[index].iconActive?.withRenderingMode(.alwaysOriginal)
            viewControllers[index].tabBarItem.image = tabBarItems[index].iconDeactive?.withRenderingMode(.alwaysOriginal)
            viewControllers[index].tabBarItem.tag = index
            viewControllers[index].title = tabBarItems[index].title
        }
    }
    
    private func setupTransparentForTabBar() {
        let transparentBlackColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.95)
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        transparentBlackColor.setFill()
        UIRectFill(rect)
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            tabBarController?.tabBar.backgroundImage = image
        }
        UIGraphicsEndImageContext()
    }
}

