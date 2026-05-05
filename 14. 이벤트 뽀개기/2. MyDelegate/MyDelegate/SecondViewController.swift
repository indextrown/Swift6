//
//  SecondViewController.swift
//  MyDelegate
//
//  Created by 김동현 on 4/30/25.
//

import UIKit

/// 1
protocol CustomTextFieldDelegate: AnyObject {
    func textDidInput(text: String)
}

final class SecondViewController: UIViewController {
    /// 2
    weak var delegate: CustomTextFieldDelegate? = nil
    
    // MARK: - UI Components
    private lazy var texxtField: UITextField = {
        let textField = UITextField()
        
        // placeholder 스타일
        textField.attributedPlaceholder = NSAttributedString(
            string: "입력해주세요",
            attributes: [.foregroundColor: UIColor.lightGray]
        )
        
        // 왼쪽 여백
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        
        // 테두리 스타일
        textField.layer.borderColor = UIColor.black.cgColor // 테두리 색상
        textField.layer.borderWidth = 1.0 // 테두리 둑께
        textField.layer.cornerRadius = 10 // 둘글게
        
        return textField
    }()
    
    private lazy var endButton: UIButton = {
        let button = UIButton()
        button.setTitle("secondView", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemMint
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        /// print("delegate 상태:", delegate as Any)
        makeUI()
    }
    
    private func makeUI() {
        // MARK: - 뷰 추가
        [texxtField, endButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // MARK: - 제약조건 설정
        // 텍스트필드
        NSLayoutConstraint.activate([
            // 위치
            texxtField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            texxtField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            // 크기
            texxtField.heightAnchor.constraint(equalToConstant: 50),
            texxtField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        // 버튼
        NSLayoutConstraint.activate([
            // 위치 제약
            endButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            endButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // 크기 제약
            endButton.heightAnchor.constraint(equalToConstant: 50),
            endButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    @objc
    private func goBack() {
        let text = texxtField.text ?? ""
        self.delegate?.textDidInput(text: text)
        self.dismiss(animated: true)
    }
}

#Preview {
    FirstViewController()
}
