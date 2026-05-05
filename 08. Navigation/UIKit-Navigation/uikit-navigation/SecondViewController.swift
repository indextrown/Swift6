//
//  SecondViewController.swift
//  uikit-navigation
//
//  Created by 김동현 on 3/30/25.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onPushBtnClicked(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let thirdVC = storyboard.instantiateViewController(identifier: "ThirdViewController") as? ThirdViewController {
            self.navigationController?.pushViewController(thirdVC, animated: true)
        }
    }
    
    // 뒤로가기 1번 방식(NavigationController에서 pop하는 방식)
    // 계속 깊어지면 바로 첫번쨰 컨트롤러로 가기 힘들다?
    @IBAction func goBackToFirstVC(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // 뒤로가기 3번 방식
    @IBAction func goBackToFirstVC3(_ sender: UIButton) {
        // self.navigationController?.popViewController(animated: true)
        self.performSegue(withIdentifier: "goBackToFirstVC", sender: self)
    }
}
