//
//  HomeViewController.swift
//  MVVMC+CleanArchitecture
//
//  Created by 김동현 on 3/27/25.
//

import UIKit

final class HomeViewController: UIViewController {
    var viewModel: HomeViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Home"

        let detailButton = UIButton(type: .system)
        detailButton.setTitle("Go to Detail", for: .normal)
        detailButton.addTarget(self, action: #selector(goToDetail), for: .touchUpInside)

        let settingsButton = UIButton(type: .system)
        settingsButton.setTitle("Go to Settings", for: .normal)
        settingsButton.addTarget(self, action: #selector(goToSettings), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [detailButton, settingsButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func goToDetail() {
        viewModel.didTapDetail()
    }

    @objc private func goToSettings() {
        viewModel.didTapSettings()
    }
}

