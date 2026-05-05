//
//  LoginVC.swift
//  RxFlowTutorialTest
//
//  Created by Jeff Jeong on 2023/07/16.
//

import UIKit
import RxFlow
import RxSwift
import RxCocoa

class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func navigateToRegister(_ sender: Any) {
        print(#fileID, #function, #line, "- ")
        let registerVC = RegisterVC.instantiate("Auth")
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @IBAction func navigateToPasswordFind(_ sender: Any) {
        print(#fileID, #function, #line, "- ")
        let passwordFindVC = PasswordFindVC.instantiate("Auth")
        self.navigationController?.pushViewController(passwordFindVC, animated: true)
    }
    
    @IBAction func navigateToAuthCheck(_ sender: Any) {
        print(#fileID, #function, #line, "- ")
        let authCheckVC = AuthCheckVC.instantiate("Auth")
        self.navigationController?.pushViewController(authCheckVC, animated: true)
    }
    
    @IBAction func navigateToEmailFind(_ sender: Any) {
        print(#fileID, #function, #line, "- ")
        let emailFindVC = EmailFindVC.instantiate("Auth")
        self.navigationController?.pushViewController(emailFindVC, animated: true)
    }
    
    @IBAction func loginSuccess(_ sender: Any) {
        print(#fileID, #function, #line, "- ")
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginSuccessAndNavtoMaintab(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
}

