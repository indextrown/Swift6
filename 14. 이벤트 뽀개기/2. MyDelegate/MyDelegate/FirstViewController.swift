//
//  FirstViewController.swift
//  MyDelegate
//
//  Created by 김동현 on 4/30/25.
//

import UIKit

final class FirstViewController: UIViewController {
    
    // MARK: - UI Components
    private lazy var myLabel: UILabel = {
        let label = UILabel()
        label.text = "hello world"
        label.textColor = .white
        return label
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("secondView", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemMint
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(goNextView), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
    
    func makeUI() {
        // MARK: - 뷰 추가
        [myLabel, nextButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // MARK: - 제약조건 설정
        // 레이블
        NSLayoutConstraint.activate([
            myLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // 버튼
        NSLayoutConstraint.activate([
            // 위치 제약
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // 크기 제약
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            nextButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    @objc
    func goNextView() {
        let secondVC = SecondViewController()
        secondVC.delegate = self
        self.present(secondVC, animated: true)
    }
}

/// 3
extension FirstViewController: CustomTextFieldDelegate {
    func textDidInput(text: String) {
        myLabel.text = text
    }
}

#Preview {
    FirstViewController()
}
