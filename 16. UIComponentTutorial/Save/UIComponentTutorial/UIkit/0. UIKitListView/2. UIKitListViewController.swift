//
//  2. UIKitListViewController.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 5/31/25.
//

import UIKit

final class UIKitListViewController: UIViewController {
    
    let listVC = ListViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addChild(listVC)
        view.addSubview(listVC.view)
        listVC.view.translatesAutoresizingMaskIntoConstraints = false
        listVC.didMove(toParent: self)
        NSLayoutConstraint.activate([
            listVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            listVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            listVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        listVC.navigationControllerRef = self.navigationController
        listVC.applyMenu(menuData)
        self.title = "메뉴"
    }
}

#Preview {
    UIKitListViewController()
}

