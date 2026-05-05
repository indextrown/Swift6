//
//  TodosViewController.swift
//  TodosUI
//
//  Created by 김동현 on 12/12/25.
//  Copyright © 2025 tuist.io. All rights reserved.
//

import UIKit

public final class TodosViewController: UIViewController {
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(.required, for: .vertical)
        label.font = .boldSystemFont(ofSize: 34)
        label.textColor = .black
        label.text = "TodosVC"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public override func loadView() {
        super.loadView()
        print(#fileID, #function, #line, "- ")
        
        self.view.backgroundColor = UIColor.systemMint
        self.view.addSubview(contentLabel)
        NSLayoutConstraint.activate([
            contentLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            contentLabel.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        print(#fileID, #function, #line, "- ")
    }
}


