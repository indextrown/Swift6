//
//  LoginViewController.swift
//  MyCoordinator
//
//  Created by 김동현 on 4/20/25.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {
    private let loginViewModel = LoginViewModel()
    
    weak var coordinator: LoginCoordinator?
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var testButton: UIButton = {
        let button = UIButton()
        button.setTitle("테스트", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        bindingViewModel()
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
        
        view.addSubview(testButton)
        testButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            testButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            testButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func bindingViewModel() {
        let input = testButton.rx.tap.asObservable()
        loginViewModel.bindTestBtn(input)
    }
}

private extension LoginViewController {
    @objc func buttonTapped() {
        coordinator?.login()
    }
}

#Preview {
    LoginViewController()
}
