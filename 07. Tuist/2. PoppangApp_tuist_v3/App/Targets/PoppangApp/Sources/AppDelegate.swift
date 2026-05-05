import UIKit
import SwiftUI

import HomeKit
import HomeUI

import TodosKit
import TodosUI

import MyPageKit
import MyPageUI

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
        
        let mainTabbarController = UITabBarController()
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house.fill"), tag: 0)
        
        let todosVC = TodosViewController()
        todosVC.tabBarItem = UITabBarItem(title: "할일목록", image: UIImage(systemName: "list.clipboard.fill"), tag: 1)
        
        let openChatVC = OpenChatVC.getInstanc()
        openChatVC.tabBarItem = UITabBarItem(title: "마이페이지 ", image: UIImage(systemName: "bubble.right.circle.fill"), tag: 2)
        
        let myPageVC = UIHostingController(rootView: MyPageView())
        myPageVC.tabBarItem = UITabBarItem(title: "마이페이지 ", image: UIImage(systemName: "person.circle.fill"), tag: 3)
        
        mainTabbarController.setViewControllers([homeVC, todosVC, openChatVC, myPageVC], animated: false)
        mainTabbarController.view.backgroundColor = .white
        
        window?.rootViewController = mainTabbarController
        window?.makeKeyAndVisible()
        
        HomeKit.hello()
        HomeUI.hello()
        
        TodosKit.hello()
        TodosUI.hello()
        
        MyPageKit.hello()
        MyPageUI.hello()
        
        OpenChatKit.hello()
        OpenChatUI.hello()
        
        return true
    }
}
