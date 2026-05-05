//
//  FavoriteVC.swift
//  RxFlowTutorialTest
//
//  Created by Jeff Jeong on 2023/07/16.
//

import UIKit
import RxFlow
import RxCocoa
import RxSwift
import RxRelay

class FavoriteVC: UIViewController {

    @IBOutlet weak var userTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func navigateToPostDetail(_ sender: Any) {
        
        let userInput = userTextField.text ?? ""
    }
}
