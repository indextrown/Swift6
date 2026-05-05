//
//  ViewController.swift
//  rx-tutorial
//
//  Created by 김동현 on 4/8/25.
//

import UIKit
import RxSwift
import RxRelay

class ViewController: UIViewController {
    
    /// element: 보내지는 이벤트 흐름 자료형/Int 타입의 빈 Observable
    var someObservable: Observable<Int> = Observable.empty() // MARK: - 기생하는존재
    var singleDisposable: Disposable? = nil

    // MARK: - 구독들을 한꺼번에 자동 정리하기 위한 '쓰레기통'
    /// RxSwift에서 메모리 관리를 위해 필요한 객체 (버리는 쓰레기통)
    /// ViewController가 메모리에서 사라질 떄 deinit()될때 disposeBag이 같이 버려진다는 의미이다.
    /// 이 disposeBag에 등록된 구독(subscription)들은 disposeBag이 해제되면서 자동으로 dispose(정리)된다.
    /// 즉, disposeBag이 살아있는 동안에는 이벤트를 계속 받을 수 있으며,
    /// disposeBag이 해제되면 더 이상 이벤트를 받지 않는다.
    let disposeBag = DisposeBag()
    
    // 흘러들어오는 데이터가 비어있는 퍼블리시 서브젝트
    var buttonClickPublishSubject: PublishSubject = PublishSubject<Void>()
    
    // MARK: - 특정 구독을 따로 저장해뒀다가 수동으로 끊을 수 있는 도구
    var buttonClickDisposable: Disposable? = nil
    
    
    // MARK: - Behavior Relay(초기값 필요) - 마지막 데이터 상태 유지
    var userInputBehaviorRelay: BehaviorRelay = BehaviorRelay<String>(value: "초기값")
    
    var clickCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - 만들면 한번 보내고 끝난다
        /// myJust 는 클로저 형태로 작성된 Observable를 생성하는 사용자 정의 함수이다.
        /// 기본적인 옵저버블을 만드는 연산자가 create다
        /// Observable.create를 사용하여 직접 이벤트(onNext, onCompleted)를 방출한다.
        /// Disposables.create()는 리소스를 해제할 때 호출한다.
        let myJust = { (element: String) -> Observable<String> in
            return Observable.create { observer in
                observer.on(.next(element))
                observer.on(.next(element))
                observer.on(.next(element))
                observer.on(.next(element))
                observer.on(.next(element))
                observer.on(.next(element))
                observer.on(.completed)
                return Disposables.create()
            }
        }

        /*
        /// 1. Observable - 한번 보내고 끝낼때 사용한다.
        /// 실행
        myJust("hello world")
            .subscribe { print($0) }  // 구독
            .disposed(by: disposeBag) // 구독 버리기
         */
        
        /*
        /// 1. 한번 실행되고 isDisposed된다
        /// 2. Observable.create하면 시작이 있고 끝이 있는 형태이고 나뭇잎 6개가 한번에 들어간 것
        self.singleDisposable = myJust("11")
            .debug("[디버그1]")
            .subscribe { print($0) }  // 구독
       */
        
        /*
        // MARK: - 버튼을 누를떄마다 이벤트를 보낸다 - 계속 연결되야하기떄문에 PublishSubject사용한다.
        /// 3. subject - 흐름이 끊기지 않는 형태(끊을 수 있음)
        buttonClickDisposable = buttonClickPublishSubject
            .debug("[디버그2]")
            .subscribe(onNext: {
                print(#fileID, #function, #line, "- ")
            })
        */
        userInputBehaviorRelay
            .debug("[디버그]") // Observable<String>
            .map { $0.count } // Observable<Int>
            .subscribe { userInput in
                print(#fileID, #function, #line, "- \(userInput)")
            }
            .disposed(by: disposeBag)
    }
    
    @IBAction func onSubjectButtonClicked(_ sender: UIButton) {
        buttonClickPublishSubject.onNext(())
        clickCount += 1
        
        // 버튼이 4번쨰 누를떄 콘선트를 뺸다는 느낌 -> isDisposed
        if clickCount > 3 {
            // MARK: - 버튼을 끊는 3가지 방법
            buttonClickDisposable?.dispose()
            // buttonClickPublishSubject.onError()
            // buttonClickPublishSubject.onCompleted()
        }
    }
    
    @IBAction func onUserInputChanged(_ sender: UITextField) {
        print(#fileID, #function, #line, "- \(sender.text!)")
        userInputBehaviorRelay.accept(sender.text ?? "")
        print(userInputBehaviorRelay.value)
    }
}

