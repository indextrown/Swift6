import UIKit
import TodosKit
import TodosUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = TodosViewController()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        TodosKit.hello()
        TodosUI.hello()

        return true
    }

}
