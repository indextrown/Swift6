//
//  HomeViewController.swift
//  HomeUI
//
//  Created by 김동현 on 12/12/25.
//  Copyright © 2025 tuist.io. All rights reserved.
//

import UIKit
import Foundation

// Home(프레임워크 외부)이 HomeUI(프레임워크 내부)를 알게 하기 위해 public로 설정해야함
public final class HomeViewController: UIViewController {
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(.required, for: .vertical)
        label.font = .boldSystemFont(ofSize: 34)
        label.textColor = .black
        label.text = "HomeVC"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public override func loadView() {
        super.loadView()
        print(#fileID, #function, #line, "- ")
        
        self.view.backgroundColor = UIColor.systemYellow
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

