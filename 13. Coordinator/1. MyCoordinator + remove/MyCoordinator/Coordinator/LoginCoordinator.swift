//
//  LoginCoordinator.swift
//  MyCoordinator
//
//  Created by 김동현 on 4/20/25.
//

import UIKit

/// 대리자 설정
protocol LoginCoordinatorDelegate {
    func didLoggedIn(_ coordinator: LoginCoordinator)
}

// LoginCoordinator
class LoginCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    /// 대리자 설정
    var delegate: LoginCoordinatorDelegate?
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let loginViewController = LoginViewController()
        loginViewController.coordinator = self
        navigationController.setViewControllers([loginViewController], animated: true)
        // navigationController.pushViewController(loginViewController, animated: true)
    }
    
    func login() {
        print("로그인 코디")
        delegate?.didLoggedIn(self)
    }
}
