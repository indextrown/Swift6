//
//  SceneDelegate.swift
//  MVVM+CleanArchitecture+Rx
//
//  Created by 김동현 on 4/3/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        window = UIWindow(windowScene: windowScene)
        
        
        /*
        // 코어데이터 생성
        let coredata = UserCoreData(viewContext: appDelegate.persistentContainer.viewContext)
        // 네트워크 객체 생성
        let network = UserNetwork(manager: NetworkManager(session: UserSession()))
        let userRP = UserRepository(coreData: coredata, network: network) // 프로토콜 생성자 안써도 되긴 함 그러면 이렇게 할 필요 없긴 함(선택)
        let userUC = UserListUsecase(repository: userRP)
        let userVM = UserListViewModel(usecase: userUC)
        let userVC = UserListViewController(viewModel: userVM)
        let userNC = UINavigationController(rootViewController: userVC)
        window?.rootViewController = userNC
        window?.makeKeyAndVisible()
         */

        
        
        // MARK: - DIContainer 주입 방식 1
        /*
        setupDI(appDelegate: appDelegate)
        // 💡 ViewModel 주입 없이 DI에서 resolve
        let userVC = UserListViewController(viewModel: DIContainer.shared.resolve(UserListViewModel.self))
        let navigation = UINavigationController(rootViewController: userVC)

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
         */
        
        setupDI(appDelegate: appDelegate)
        let usecase = DIContainer.shared.resolve(UserListUsecase.self)
        let viewModel = UserListViewModel(usecase: usecase)
        let userVC = UserListViewController(viewModel: viewModel)
        let navigation = UINavigationController(rootViewController: userVC)

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
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

    private func setupDI(appDelegate: AppDelegate) {
        let coredata = UserCoreData(viewContext: appDelegate.persistentContainer.viewContext)
        let network = UserNetwork(manager: NetworkManager(session: UserSession()))
        
        let repository = UserRepository(coreData: coredata, network: network)
        let usecase = UserListUsecase(repository: repository)
        
        DIContainer.shared.register(UserListUsecase.self, dependency: usecase)
    }


    
    /*
    private func setupDI(appDelegate: AppDelegate) {
        let coredata = UserCoreData(viewContext: appDelegate.persistentContainer.viewContext)
        let network = UserNetwork(manager: NetworkManager(session: UserSession()))
        
        let repository = UserRepository(coreData: coredata, network: network)
        let usecase = UserListUsecase(repository: repository)
        let viewModel = UserListViewModel(usecase: usecase)

        let container = DIContainer.shared
        container.register(UserListViewModel.self, dependency: viewModel)
    }
     */


}

