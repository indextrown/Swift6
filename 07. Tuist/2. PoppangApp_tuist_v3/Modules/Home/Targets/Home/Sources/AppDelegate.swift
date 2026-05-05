import UIKit
import HomeKit
import HomeUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = HomeViewController()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        HomeKit.hello()
        HomeUI.hello()

        return true
    }

}
