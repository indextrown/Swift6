//
//  HomeCoordinator.swift
//  MyCoordinator
//
//  Created by 김동현 on 4/20/25.
//

import UIKit

/// 대리자 설정
protocol HomeCoordinatorDelegate {
    func didLoggedOut(_ coordinator: HomeCoordinator)
}

// HomeCoordinator
class HomeCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    /// 대리자 설정
    var delegate: HomeCoordinatorDelegate?
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let homeViewController = HomeViewController()
        homeViewController.coordinator = self
        navigationController.setViewControllers([homeViewController], animated: true)
    }
    
    func logout() {
        print("로그아웃 코디")
        delegate?.didLoggedOut(self)
    }
}
