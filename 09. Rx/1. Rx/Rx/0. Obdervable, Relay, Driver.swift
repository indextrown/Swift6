//
//  0. Obdervable, Relay, Driver.swift
//  Rx
//
//  Created by 김동현 on 4/9/25.
//

/*
 reference
 - https://nsios.tistory.com/54
 - https://nsios.tistory.com/71
 https://green1229.tistory.com/187
 
 Observable
 - 방출기능(발생된 이벤트를 뿌려준다
 - onNext, accept등을 통해 이벤트 방출 가능하다
 
 Observer
 - subscribe(이벤트 발생), drive등을 통해 이벤트를 구독할 수 있다
 - Cold Observable - Observable을 구독할 때 이벤트가 방출되기 때문에 이벤트 전부를 받을 수 있다
 
 Subject
 - Observable에 값을 추가하고 방출할 수 있다
 - Observable이자 Observer기능을 할 수 있어서 구독 + 이벤트 방출 둘다 가능
 - HotObservable - 구독한 시점부터 방출되는 이벤트만 받을 수 있다
 - 어떤 항목을 방출할 것인지에 대한 정의가 없다 -> 개발자가 원하는 시점마다 항목을 방출 가능하다
 
 Relay
 - Subject와 달리 .onCompleted, .onError가 없다!
 - UI에서 자주 쓰이는 이유: 끊기지 않음 (안전함)
 - Subject를 한번 wrapping해서 error나 complete가 없어서 끊기지 않는다
 - relay구독시 2가지 방법 존재 subscribe/asDriver(메인스레드 자동 처리)
 
 Driver
  - 항상 메인스레드에서 동작
  - UI 바인딩에 최적화된 Observable의 특수한 형태
  - 에러가 발생하지 않음 → 스트림이 끊기지 않아 안전함
  - share(replay: 1) 특성을 가져서 여러 구독자에게 같은 값을 전달함 (공유됨)
  - drive()를 통해 구독하며, UI 요소 바인딩에 적합
  - ViewModel → View 데이터 바인딩에서 자주 사용됨
  - asDriver(onErrorJustReturn:) 등을 통해 Observable을 Driver로 변환 가능
  - 내부적으로 BehaviorRelay처럼 가장 최신값을 전달
 */

import Foundation
import RxSwift
import RxRelay
import RxCocoa

// 메모리누수 방지 도구 - 구독한 것은 명시적으로 dispose핮지 않으면 계속 살아있기떄문에 DisposeBag에 넣어줘야 자동으로 정리된다.
let disposeBag = DisposeBag()
@main
struct Main {
    static func main() {
        /*
        // MARK: - 1. Observable - 여러 값을 순차적으로 방출하는 스트림
        let observableOf = Observable<String>.of("1", "2", "3")
        
        // 1. 옵저버 - 구독
        observableOf.subscribe { value in // onNext
            print(value)
        } onCompleted: {
            print("스트림 종료")
        }
        .disposed(by: disposeBag)
        /*
         1
         2
         3
         스트림 종료
         */

        // MARK: - 2. Subjet 예시
        let subject = PublishSubject<String>()
        
        subject.subscribe { value in
            print("첫 번째 Observer가 받는 항목: \(value)")
        } onCompleted: {
            print("subject1 종료")
        }
        .disposed(by: disposeBag)

        subject.onNext("subject 1")
        subject.onNext("subject 2")
        
        subject.subscribe { value in
            print("두 번째 Observer가 받는 항목: \(value)")
        } onCompleted: {
            print("subject2 종료")
        }
        .disposed(by: disposeBag)
        subject.onNext("subject 3")
        
        // 종료
        subject.onCompleted()
        /*
         첫 번째 Observer가 받는 항목: subject 1
         첫 번째 Observer가 받는 항목: subject 2
         첫 번째 Observer가 받는 항목: subject 3
         두 번째 Observer가 받는 항목: subject 3
         subject1 종료
         subject2 종료
         */
        */
        
        // MARK: - 릴레이 - 끊기지 않음 - 강제종료 불가
        let relay = PublishRelay<String>()
        // relay.accept("hello") // 먼저 만들면 출력안됨
        
        relay.subscribe(onNext: { value in
            print(value)
        })
        .disposed(by: disposeBag)
        relay.accept("hello")

        // MARK: - Driver는 UI 바인딩에 특화된 RxCocoa스트림 타입
        // ViewModel -> View 바인딩에 사용된다
        let name = BehaviorRelay(value: "동현")
        let nameDriver = name
            .map { "hello world \($0)" }
            .asDriver(onErrorJustReturn: "에러")
        
        nameDriver
            .drive(onNext: { print($0) })
                .disposed(by: disposeBag)
        
    }
}
