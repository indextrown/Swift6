//
//  HomeVC.swift
//  RxFlowTutorialTest
//
//  Created by Jeff Jeong on 2023/07/16.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var userInputTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func navigateToPostDetail(_ sender: Any) {
        print(#fileID, #function, #line, "- ")
        
        let userInput = userInputTextField.text ?? ""        
    }
}
