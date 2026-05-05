//
//  AppCoordinator.swift
//  MyCoordinator
//
//  Created by 김동현 on 4/20/25.
//

import UIKit

class AppCoordinator: Coordinator, HomeCoordinatorDelegate {
    
    /// protocol
    var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController
    private var isLoggedIn: Bool
    
    init(navigationController: UINavigationController, isLoggedIn: Bool) {
        self.navigationController = navigationController
        self.isLoggedIn = isLoggedIn
    }
    
    /// protocol - 보여줄 화면 분기처리
    func start() {
        if isLoggedIn {
            showHomeViewController()
        } else {
            showLoginViewController()
        }
    }
    
    /// LoginCoordinator를 만들고 start() 호출
    private func showLoginViewController() {
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        loginCoordinator.delegate = self
        childCoordinators.append(loginCoordinator)
        loginCoordinator.start()
    }
    
    /// HomeCoordinator를 만들고 start() 호출
    private func showHomeViewController() {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        homeCoordinator.delegate = self
        childCoordinators.append(homeCoordinator)
        homeCoordinator.start()
    }
}

extension AppCoordinator: LoginCoordinatorDelegate {
    func didLoggedIn(_ coordinator: LoginCoordinator) {
        /// AppCoordinator가 관리하고 있는 Coordinator 배열에서 LoginCoordinator를 제거한다는 의미.
        self.childCoordinators = childCoordinators.filter {$0 !== coordinator }
        showHomeViewController()
    }
    
    func didLoggedOut(_ coordinator: HomeCoordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== coordinator }
        self.showLoginViewController()
    }
}
