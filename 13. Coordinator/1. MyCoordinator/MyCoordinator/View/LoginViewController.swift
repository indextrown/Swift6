//
//  LoginViewController.swift
//  MyCoordinator
//
//  Created by 김동현 on 4/20/25.
//

import UIKit

final class LoginViewController: UIViewController {
    
    weak var coordinator: LoginCoordinator?
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        print("로그인뷰")
    }
    
    private func makeUI() {
        view.backgroundColor = .systemPink
        
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

private extension LoginViewController {
    @objc func buttonTapped() {
        coordinator?.login()
    }
}
