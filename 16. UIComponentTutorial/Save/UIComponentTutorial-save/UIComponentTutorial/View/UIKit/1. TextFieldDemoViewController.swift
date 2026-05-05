//
//  TextFieldDemoViewController.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 5/19/25.
//

import UIKit

final class TextFieldDemoViewController: UIViewController {

    private let label: UILabel = {
        let label = UILabel()
        label.text = "아래에 텍스트를 입력하세요"
        return label
    }()
    
    private let textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "입력"
        tf.borderStyle = .roundedRect
        return tf
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "TextField 데모"
        setupLayout()
    }

    private func setupLayout() {
        [label, textField].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
}
