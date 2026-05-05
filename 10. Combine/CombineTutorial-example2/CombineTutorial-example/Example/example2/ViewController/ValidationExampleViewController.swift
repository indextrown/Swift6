//
//  ValidationExampleViewController.swift
//  CombineTutorial-example
//
//  Created by 김동현 on 7/18/25.
//

import UIKit
import Combine
import CombineCocoa

private let minimalUserNameLength = 5
private let minimalPasswordLength = 5

class ValidationExampleViewController: UIViewController {
    private var subscriptions: Set<AnyCancellable> = Set()
    
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var userNameValidationLabel: UILabel!
    
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passwordValidationLabel: UILabel!
     
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameValidationLabel.text = "Username has to be at least \(minimalUserNameLength) characters"
        passwordValidationLabel.text = "Password has to be at least \(minimalPasswordLength) characters"
        
        /*
         usernameValid를 세군대에서 구독중이다
         구독할때마다 로직이 타진다
         rx는 share로 해결한다 -> 한번 구독하면 로직이 더 타지 않게 해준다
         combine은 .share()를 사용한다
         .share()는 하나의 스트림을 여러 subscriber가 공유하게 만드는 멀티캐스트 연산자이다
         
         ❌ .share() 없이
         userNameTF.textPublisher
             ├─> map() → 구독 1 (map 실행됨)
             ├─> map() → 구독 2 (map 또 실행됨)
             └─> map() → 구독 3 (map 또 또 실행됨)
         
         ✅ .share() 사용 시
         userNameTF.textPublisher
             └─> map() → share() → 구독 1, 2, 3 (map 딱 한 번 실행됨)
         
         
         usernameValid는 아래에서 3번 구독되고 있다.
         - 각각 구독할 때마다 `.map` 로직이 3번 중복 실행된다 (비효율적!)
         
         RxSwift에서는 `.share()`를 붙이면 한 번만 실행되도록 해결했었고,
         Combine에서도 같은 개념의 `.share()` 연산자를 제공한다.
         
         → `.share()`를 붙이면 하나의 stream을 여러 subscriber가 공유하게 되어,
            map 등 부가 연산이 **한 번만 실행된다.**

         */
        let usernameValid: AnyPublisher<Bool, Never> = userNameTF.textPublisher
            .compactMap { $0 }
            .map { (element: String) -> Bool in
                print(#fileID, #function, #line, "- ")
                return element.count >= minimalUserNameLength
            }
            .share()
            .eraseToAnyPublisher()
         
        let passwordValid: AnyPublisher<Bool, Never> = passwordTF.textPublisher
            .compactMap { $0 }
            .map { (element: String) -> Bool in
                print(#fileID, #function, #line, "- ")
                return element.count >= minimalPasswordLength
            }
            .share()
            .eraseToAnyPublisher()
        
        let everythingValid: AnyPublisher<Bool, Never> = Publishers.CombineLatest(usernameValid, passwordValid)
            .map { (isUsernameValid, isPasswordValid) -> Bool in
                return isUsernameValid && isPasswordValid
            }.eraseToAnyPublisher()
        
        usernameValid
            .assign(to: \.isEnabled, on: passwordTF)
            .store(in: &subscriptions)
        
        usernameValid
            .assign(to: \.isHidden, on: userNameValidationLabel)
            .store(in: &subscriptions)
        
        // MARK: - 값이 들어오면 receiveValue, 값이 끊기거나 다른것도 알고싶으면 밑에꺼
        usernameValid
            .sink { completion in
                switch completion {
                case .finished:
                    print(#fileID, #function, #line, "- ")
                case .failure(let error):
                    print(#fileID, #function, #line, "- error: \(error)")
                }
            } receiveValue: { element in
                print(#fileID, #function, #line, "- element: \(element)")
            }
            .store(in: &subscriptions)
        
        
        passwordValid
            .assign(to: \.isHidden, on: passwordValidationLabel)
            .store(in: &subscriptions)
        
        everythingValid
            .assign(to: \.isEnabled, on: loginButton)
            .store(in: &subscriptions)
        
        loginButton.tapPublisher
            .sink(receiveValue: { [weak self] _ in
                self?.showAlert()
            })
            .store(in: &subscriptions)
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "CombineExample",
                                      message: "Hello world",
                                      preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
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
