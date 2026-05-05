//
//  HomeViewController.swift
//  MyCoordinator
//
//  Created by 김동현 on 4/20/25.
//

import UIKit

final class HomeViewController: UIViewController {
    
    weak var coordinator: HomeCoordinator?
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
    
    private func makeUI() {
        view.backgroundColor = .green
        
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

private extension HomeViewController {
    @objc func buttonTapped() {
        coordinator?.logout()
    }
}



