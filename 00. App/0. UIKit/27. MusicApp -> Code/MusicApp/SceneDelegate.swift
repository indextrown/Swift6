//
//  SceneDelegate.swift
//  MusicApp
//
//  Created by 김동현 on 3/12/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        // 탭바 컨트롤러 생성
        let tabBarVC = UITabBarController()
        
        // 첫 화면은 네비게이션 컨트롤러(기본 루트뷰)
        let vc1 = UINavigationController(rootViewController: FirstViewController())
        let vc2 = SecondViewController()
        
        // 탭바 이름 설정
        vc1.title = "TableView"
        vc2.title = "CollectionView"
        
        // 탭바로 사용하기 위한 뷰 컨트롤러 설정
        tabBarVC.setViewControllers([vc1, vc2], animated: false)
        tabBarVC.modalPresentationStyle = .fullScreen
        tabBarVC.tabBar.backgroundColor = .white
        
        // 탭바 배경색과 appearance 설정
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground() // 불투명한 배경
        
        tabBarAppearance.backgroundColor = .black
        tabBarVC.tabBar.standardAppearance = tabBarAppearance
        
        // 선택 및 미선택 상태의 아이콘 색상을 흰색으로 지정
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = .white
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = .white
        
        // 텍스트 색상 설정: 미선택은 흰색, 선택은 초록색으로 변경
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.green]
        
        tabBarVC.tabBar.standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            tabBarVC.tabBar.scrollEdgeAppearance = tabBarAppearance
        }
        tabBarVC.tabBar.isTranslucent = false
        
        // 탭바 이미지 설정
        guard let items = tabBarVC.tabBar.items else { return }
        items[0].image = UIImage(systemName: "square.and.arrow.up")
        items[1].image = UIImage(systemName: "folder")
        
        // 기본루트뷰를 탭바컨트롤러로 설정
        window?.rootViewController = tabBarVC
        window?.makeKeyAndVisible()
        
        
        // 그냥 첫화면을 viewController로 한다면
        /*
        let vc = ViewController()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
         */
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

