//
//  LoginViewController.swift
//  Navigation&Tab
//
//  Created by 김동현 on 2/26/25.
//

import UIKit

// MARK: - delegate 패턴
protocol LoginViewControllerDelegate: AnyObject {
    func didLoginSuccessfully()
}

final class LoginViewController: UIViewController {
    
    weak var delegate: LoginViewControllerDelegate?
    
    // 로그인 버튼
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .blue
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
    
    func makeUI() {
        // view에 버튼 올리기
        view.addSubview(nextButton)
        
        // 오토 레이아웃
        NSLayoutConstraint.activate([
            nextButton.widthAnchor.constraint(equalToConstant: 120),
            nextButton.heightAnchor.constraint(equalToConstant: 45),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func nextButtonTapped() {
        // 로그인 성공 시 delegate 호출
        // MARK: - delegate 패턴
        delegate?.didLoginSuccessfully()
        dismiss(animated: true, completion: nil)
    }
}

