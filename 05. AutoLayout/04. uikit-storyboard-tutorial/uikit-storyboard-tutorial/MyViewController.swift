//
//  ViewController.swift
//  uikit-storyboard-tutorial
//
//  Created by 김동현 on 3/18/25.
//

import UIKit

class MyViewController: UIViewController {
 
    @IBOutlet var yellowView: CustomView!
    
    // 앱실행되어 viewController가 생성되면(메모리에 올라가면) viewDidload가 호출된다
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - 항상 boarderWidth는 conerRadius보다 작아야 한다
        // yellowView.layer.cornerRadius = 20
        // yellowView.layer.borderWidth = 10
        // yellowView.layer.borderColor = UIColor.blue.cgColor
        // yellowView.layer.masksToBounds = false // 내부의 노란색부분도 둥글게 하고싶다
        // yellowView.layer.cornerRadius = self.yellowView.frame.width/2
    }
}

@available(iOS 17, *)
#Preview {
  let storyboard = UIStoryboard(name: "Main", bundle: nil)
  let vc = storyboard.instantiateInitialViewController() as! MyViewController
  vc.loadViewIfNeeded()
  return vc
}

