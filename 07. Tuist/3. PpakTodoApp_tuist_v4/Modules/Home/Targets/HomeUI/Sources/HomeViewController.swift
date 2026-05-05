//
//  HomeViewController.swift
//  HomeUI
//
//  Created by Jeff Jeong on 2023/08/25.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import Foundation
import UIKit

public class HomeViewController : UIViewController {
    
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(.required, for: .vertical)
        label.font = .boldSystemFont(ofSize: 34)
        label.numberOfLines = 1
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
            contentLabel.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
        ])
        
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        print(#fileID, #function, #line, "- ")
    }
    
}
