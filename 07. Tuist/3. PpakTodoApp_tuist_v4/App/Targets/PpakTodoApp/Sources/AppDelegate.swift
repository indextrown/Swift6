import UIKit
import SwiftUI

import HomeUI
import HomeKit

import TodosKit
import TodosUI

import MyPageKit
import MyPageUI


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        
        let mainTabBarController = UITabBarController()
        
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house.fill"), tag: 0)
        
        let todosVC = TodosViewController()
        todosVC.tabBarItem = UITabBarItem(title: "할일목록", image: UIImage(systemName: "list.clipboard.fill"), tag: 1)
        
        let myPageVC = UIHostingController(rootView: MyPageView())
        myPageVC.tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(systemName: "person.circle.fill"), tag: 2)
        
        
        mainTabBarController.setViewControllers([homeVC, todosVC, myPageVC], animated: false)
        
        mainTabBarController.view.backgroundColor = .white
        window?.rootViewController = mainTabBarController
        window?.makeKeyAndVisible()
        
        HomeKit.hello()
        HomeUI.hello()
        
        TodosKit.hello()
        TodosUI.hello()
        
        MyPageKit.hello()
        MyPageUI.hello()

        return true
    }

}
