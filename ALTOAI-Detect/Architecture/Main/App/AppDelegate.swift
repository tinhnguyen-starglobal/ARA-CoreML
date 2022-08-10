import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureMainTabbar()
        return true
    }
    
    private func configureMainTabbar() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let mainVC = MainNavigationController(tabBarItems: [.outDevice, .onDevice])
        
        window.rootViewController = mainVC
        window.makeKeyAndVisible()
        self.window = window
    }
}

