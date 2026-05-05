//
//  MainViewController.swift
//  UITableViewTutorial
//
//  Created by 김동현 on 5/8/25.
//

import UIKit

class MainViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MainViewController loaded")
    }
    
    @IBAction func codeButtonTapped(_ sender: UIButton) {
        print("눌림")
        let vc = OnlyCodeBaseViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
