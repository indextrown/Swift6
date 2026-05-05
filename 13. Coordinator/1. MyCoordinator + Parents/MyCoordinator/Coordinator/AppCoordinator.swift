//
//  AppCoordinator.swift
//  MyCoordinator
//
//  Created by 김동현 on 4/20/25.
//

import UIKit

final class AppCoordinator: Coordinator {
    /// protocol
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    let navigationController: UINavigationController
    let isLoggedIn: Bool
    
    /// protocol
    func start() {
        print("앱 코디네이터 시작")
        startLoginCoordinator()
    }
    
    init(navigationController: UINavigationController, isLoggedIn: Bool) {
        self.navigationController = navigationController
        self.isLoggedIn = isLoggedIn
    }
    
    func startLoginCoordinator() {
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        loginCoordinator.parentCoordinator = self
        childCoordinators.append(loginCoordinator)
        loginCoordinator.start()
    }
    
    func startHomeCoordinator() {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        homeCoordinator.parentCoordinator = self
        childCoordinators.append(homeCoordinator)
        homeCoordinator.start()
    }
}

final class LoginCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit {
        print("로그인 코디네이터 해제")
    }
    
    func start() {
         print("로그인 코디네이터 시작")
        let loginVC = LoginViewController()
        loginVC.coordinator = self
        navigationController.setViewControllers([loginVC], animated: true)
    }
    
    /// 로그인 성공시 호출되는 메서드
    /// 나는 부모에게 끝났어 라고 알리고 부모가 다음 흐름인 홈을 시작해줘
    func didLoginSuccess() {
        /// 내가(LoginCoordinator) 끝났다는걸 상위 Coordinator에게 알려줌
        parentCoordinator?.childDidFinish(self)
        
        /// 상위 AppCoordinator는 이걸 받아서 childCoordinator 배열에서 나(LoginCoordinator)를 제거
        if let appCoordinator = parentCoordinator as? AppCoordinator {
            appCoordinator.startHomeCoordinator()
        }
    }
}

final class HomeCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit {
        print("홈 코디네이터 해제")
    }
    
    func start() {
         print("홈 코디네이터 시작")
        let homeVC = HomeViewController()
        homeVC.coordinator = self
        navigationController.setViewControllers([homeVC], animated: true)
    }
    
    func logout() {
        parentCoordinator?.childDidFinish(self)
        if let appCoordinator = parentCoordinator as? AppCoordinator {
            appCoordinator.startLoginCoordinator()
        }
    }
}



