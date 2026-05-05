//
//  1. Observable .swift
//  Rx
//
//  Created by 김동현 on 4/9/25.
//

/*
 reference
 - https://babbab2.tistory.com/182
 - https://ios-development.tistory.com/95
 - https://sujinnaljin.medium.com/rxswift-시작-497dfada1e22
 - https://1000one.tistory.com/61
 - https://eunjin3786.tistory.com/37
 - https://duwjdtn11.tistory.com/626
 
 Rx의 3요소
 - Observables<Data> - 구독 가능한것
    - 객체의 이벤트나 값 추가, 수정 가능
    - event종류: next, completed, error
    - API.downliad(file:)은
 - Observer - 관찰자
 - Subject - Observable이자 Observer이다
 
 [정리]
 Observer    .onNext(), .onError(), .onCompleted()를 통해 이벤트를 받을 수 있다
 Observable    .subscribe()를 통해 이벤트를 발행할 수 있다
 Subject    둘 다 가능하다!
 
 [차이]
 Observable
 - 이벤트를 정의하고, 정적인 스트림을 생성
 - 한 방향: 선언 → 구독
 - ✅ (클린하고 선언적)
 
 Subject
 - 외부에서 직접 값을 넣고, 동적인 스트림을 생성
 - 양방향: 입력도 받고, 출력도 함
 - ❌ (남용 시 버그 유발)
 */

import Foundation
import RxSwift

@main
struct Main {
    static func main() {
        let disposeBag = DisposeBag()
        
        // Observable - 구독 가능한것
        let observable = Observable<String>.create { observer in
            observer.onNext("hello Observable")
            return Disposables.create()
        }
        
        // Observable 구독
        observable.subscribe(onNext: { (element) in
            print(element)
        })
        .disposed(by: disposeBag)
        
        /*
         📌 여기서 일어나는 일
         subject.onNext("A") → 값 A를 발행 (Observer 역할)
         subject.onNext("B") → 값 B를 발행 (Observer 역할)
         subscribe → 가장 최근 값인 "B"가 Observable 역할로 전달됨
         즉, Subject는 중간다리 역할을 해요:

         외부로부터 값을 받고 (Observer)
         그 값을 다른 구독자에게 전달해요 (Observable)
         */
        
        // Subject - Observable이자 Observer
        let subject = BehaviorSubject(value: "")
        subject.onNext("hello Subject")
        
        // observerdurgkf: 값을 받음
        subject.onNext("A")
        subject.onNext("B")
        
        // observable 역할: subscribe를 통해 다른 observer에게 이벤트를 전달
        subject.subscribe(onNext: { (element) in
            print(element)
        })
        .disposed(by: disposeBag)
    }
}
