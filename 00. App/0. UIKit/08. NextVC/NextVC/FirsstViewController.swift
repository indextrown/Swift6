//
//  FirsstViewController.swift
//  NextVC
//
//  Created by 김동현 on 2/17/25.
//

import UIKit

final class FirsstViewController: UIViewController {

    // 클로저의 실행문 레이블
    private let mainLabel: UILabel = {
        let label = UILabel()
        // label.text = "FirstViewController"
        label.font = UIFont.systemFont(ofSize: 22)
        return label
    }()

    // 클로저의 실행문 버튼
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.blue
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(backButonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - 일반적으로 데이터를 전달받을 떄 옵셔널String으로 선언하면 생성자를 만들 필요 없다
    var someString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        configureUI()
    }
    
    // 설정
    func setUp() {
        
        mainLabel.text = someString
        
        // 화면에 올리기(가장 밑에깔린 view에 addsubview
        view.addSubview(mainLabel)
        view.addSubview(backButton)
        
        // 배경
        view.backgroundColor = .gray
    }
    
    // 오토레이아웃
    func configureUI() {
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            mainLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            
            backButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            backButton.widthAnchor.constraint(equalToConstant: 70),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func backButonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

#Preview {
    FirsstViewController()
}
