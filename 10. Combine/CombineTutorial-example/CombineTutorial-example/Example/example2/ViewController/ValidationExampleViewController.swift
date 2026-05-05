//
//  ValidationExampleViewController.swift
//  CombineTutorial-example
//
//  Created by 김동현 on 7/18/25.
//

import UIKit

class ValidationExampleViewController: UIViewController {

    
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var userNameValidationLabel: UILabel!
    
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passwordValidationLabel: UILabel!
     
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Helper Method
    // validationExampleVC를 생성하지 않고 만들어주는 역할 - 타입메서드
    class func getInstance() -> ValidationExampleViewController { // MARK: - 상속을 고료하지 않는 경우면 static func
        ValidationExampleViewController(nibName: "ValidationExampleViewController", bundle: nil)
    }
}

// MARK: - 조금 더 제네릭하게 한다면
extension UIViewController {/// nib 파일 이름이 클래스명과 동일할 때 해당 ViewController 인스턴스를 생성합니다.
    ///
    /// - Returns: nibName과 동일한 이름의 UIViewController 인스턴스
    /// - Example:
    /// ```swift
    /// let vc = MyViewController.instantiateFromNib()
    /// ```
    ///Self: 호출하는 타입 자신 (예: MyViewController)
    /// String(describing: Self.self): "MyViewController" → nib 파일 이름과 일치
    static func instantiateFromNib() -> Self {
        return Self(nibName: String(describing: Self.self), bundle: nil)
    }
}
