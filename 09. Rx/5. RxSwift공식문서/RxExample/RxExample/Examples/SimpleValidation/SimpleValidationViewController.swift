//
//  SimpleValidationViewController.swift
//  RxExample
//
//  Created by Krunoslav Zaher on 12/6/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private let minimalUsernameLength = 5
private let minimalPasswordLength = 5

class SimpleValidationViewController : ViewController {

    
    @IBOutlet weak var usernameOutlet: UITextField!  // 텍스트필드
    @IBOutlet weak var usernameValidOutlet: UILabel! // 레이블

    @IBOutlet weak var passwordOutlet: UITextField!  // 텍스트필드
    @IBOutlet weak var passwordValidOutlet: UILabel! // 레이블

    @IBOutlet weak var doSomethingOutlet: UIButton!

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameValidOutlet.text = "Username has to be at least \(minimalUsernameLength) characters"
        passwordValidOutlet.text = "Password has to be at least \(minimalPasswordLength) characters"

        // MARK: - 글자 입력 파이프라인 1 생성(옵저버블이다)
        // MARK: - 생성을 하였으면 구독을 해야한다 (subscribe 또는 bind도 해당 객체에 바로꽂기)
        // 텍스트필드 입력될떄 = 값이 변경될때 변경된 글자들을 받을 수 있도록 세팅되어 있다
        // id 입력길이가 5보다 큰가
        let usernameValid = usernameOutlet.rx.text.orEmpty
            .map {
                print("map이 탔음")
                return $0.count >= minimalPasswordLength
            } // Observable<Bool>
            .share(replay: 1) // 이거를 하지않으면 각각의 바인딩마다 .map이 호출 되어버린다
            // without this map would be executed once for each binding, rx is stateless by default
        // MARK: - 옵저버블은 구독을 한 시점에(파이프라인이 연결되어) 이벤트 전달이 된다
        // MARK: - 아래애서 구독을하면서 옵저버블을 타기 때문에 map으로 계속 타버리게 된다.
        // MARK: - map로직을 한번만 계산해서 공유를 하고싶을때 share를 쓴다.(구독 상태 다같이 공유)
        // MARK: - replay: 1 - 마지막에 보낸거를 공유한다
 
        // MARK: - 그글자 입력 파이프라인 2
        // pw 입력길이가 5보다 큰가
        let passwordValid = passwordOutlet.rx.text.orEmpty
            .map { $0.count >= minimalPasswordLength } // Observable<Bool>
            .share(replay: 1)

        // MARK: - CombineLatest로 두가지 물줄기(파이프라인)을 하나로 합쳐서 새로운 물줄기로 생성
        let everythingValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }
            .share(replay: 1)
        
        // MARK: - 구독쪽에서 bind하였다
        // id 입력길이가 5보다 크면 비밀번호 입력 가능해짐
        usernameValid
            .bind(to: passwordOutlet.rx.isEnabled) // 구독과 동시에 텍스트필드가 가진 isEnabled 프로퍼티에 꽂음(연결)
            .disposed(by: disposeBag)

        // id 입력길이가 5보다 크면 빨간글자 숨김
        usernameValid
            .bind(to: usernameValidOutlet.rx.isHidden) // 구독과 동시에 label이 가진 isEnabled 프로퍼티에 꽂음
            .disposed(by: disposeBag)
        
        usernameValid
            .subscribe { event in

                switch event {
                case .next(let element):
                    print("next: \(element)")
                case .error(let error):
                    print("error: \(error)")
                case .completed:
                    print("complete")
                }
            }
            .disposed(by: disposeBag)

        // pw 입력길이가 5보다 크면 빨간글자 숨김
        passwordValid
            .bind(to: passwordValidOutlet.rx.isHidden) //
            .disposed(by: disposeBag)

        // 모두 총족하면 doSomething버튼 클릭 가능해짐
        everythingValid
            .bind(to: doSomethingOutlet.rx.isEnabled) //
            .disposed(by: disposeBag)

        doSomethingOutlet.rx.tap
            .subscribe(onNext: { [weak self] _ in self?.showAlert() })
            .disposed(by: disposeBag)
    }

    func showAlert() {
        let alert = UIAlertController(
            title: "RxExample",
            message: "This is wonderful",
            preferredStyle: .alert
        )
        let defaultAction = UIAlertAction(title: "Ok",
                                          style: .default,
                                          handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
}
