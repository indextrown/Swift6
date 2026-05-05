//
//  ProfileVC.swift
//  RxFlowTutorialTest
//
//  Created by Jeff Jeong on 2023/07/16.
//

import UIKit

class ProfileVC: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
 
    @IBAction func navigateToProfileSetting(_ sender: Any) {
        print(#fileID, #function, #line, "- ")
    }
    
    @IBAction func userLogoutWithNotification(_ sender: Any) {
        print(#fileID, #function, #line, "- ")
        NotificationCenter.default.post(name: .userLoggedOutEvent, object: nil)
    }
    
    
    @IBAction func userLogoutWithParentStep(_ sender: Any) {
        print(#fileID, #function, #line, "- ") 
        self.navigationController?.popViewController(animated: true)
    }
    
}
