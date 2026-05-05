//
//  DetailViewController.swift
//  MVVMC+CleanArchitecture
//
//  Created by 김동현 on 3/27/25.
//

import UIKit

final class DetailViewController: UIViewController {
    var viewModel: DetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        title = "Detail"

        let label = UILabel()
        label.text = "This is the Detail Screen"
        label.textColor = .white

        let button = UIButton(type: .system)
        button.setTitle("Go Back", for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [label, button])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func goBack() {
        viewModel.didTapBack()
    }
}
