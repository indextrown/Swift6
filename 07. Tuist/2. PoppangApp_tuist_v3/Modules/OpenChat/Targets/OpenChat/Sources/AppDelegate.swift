import UIKit
import OpenChatKit
import OpenChatUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = OpenChatVC.getInstanc()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        OpenChatKit.hello()
        OpenChatUI.hello()

        return true
    }

}
