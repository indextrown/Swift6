//
//  AppCoordinator.swift
//  MVVMC+CleanArchitecture
//
//  Created by 김동현 on 3/27/25.
//

import UIKit

final class AppCoordinator {
    let window: UIWindow
    let navigationController: UINavigationController

    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }

    func start() {
        let homeVC = HomeViewController()
        homeVC.viewModel = HomeViewModel(coordinator: self)
        navigationController.viewControllers = [homeVC]
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    func showDetail() {
        let vc = DetailViewController()
        vc.viewModel = DetailViewModel(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }

    func showSettings() {
        let vc = SettingsViewController()
        vc.viewModel = SettingsViewModel(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }

    func pop() {
        navigationController.popViewController(animated: true)
    }
}
