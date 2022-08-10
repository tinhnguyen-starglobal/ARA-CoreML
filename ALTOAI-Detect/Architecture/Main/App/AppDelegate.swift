import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    private func configureMainTabbar() {
        let mainVC = MainNavigationController(tabBarItems: [.search, .library, .profile])
        UIWindow.setRoot(by: mainVC, animated: true)
    }
}
