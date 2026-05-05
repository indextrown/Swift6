//
//  AnyPublisher.swift
//  SwiftSkillCLT
//
//  Created by 김동현 on 1/14/25.
//

/*
 AnyPublisher
 - Combine 프레임워크에서 제공하는 타입으로, 다양한 Publisher를 일반화하여 사용할 수 있도록 해줍니다.
 - Combine은 Apple의 반응형 프로그래밍 프레임워크로, 데이터 스트림을 처리하고 비동기 이벤트를 처리하기 위해 사용됩니다.
 - AnyPublisher는 주로 유형을 숨기고, 다양한 Publisher를 하나의 공통 타입으로 다룰 때 사용됩니다.
 - Combine에서는 Publisher 프로토콜을 준수하는 여러 타입이 있지만, 종종 반환 타입을 명시적으로 선언하기 어려운 경우가 있습니다.
 - 이런 상황에서 AnyPublisher를 사용하여 코드의 유연성과 가독성을 높일 수 있습니다.
 
 MARK: 특징
 타입 지우기(Type Erasure)
 - 내부에 포함된 Publisher의 구체적인 타입을 감추고, AnyPublisher로 캡슐화합니다.
 유연한 반환 타입
 - 호출하는 측에서는 구체적인 Publisher의 타입에 신경 쓰지 않고 AnyPublisher로 처리할 수 있습니다.
 
 MARK: 선언
 - AnyPublisher<Output, Failure>
 Output: Publisher가 방출하는 값의 타입
 Failure: Publisher가 방출하는 에러의 타입 (에러가 없을 경우 Never)
 
 
 - 여러 Publisher를 같은 타입으로 처리할 수 있어 코드의 가독성과 유지보수성이 향상된다
 - 내부 구현을 외부로 노출하지 않고, 간단하고 깔끔한 인터페이스를 제공한다
 - 복잡한 Combine 체인에서 발생하는 긴 타입명을 단순하게 관리할 수 있다
 - Mock 데이터와 Publisher를 간단히 주입하여 테스트를 쉽게 구현할 수 있다
 */
import Combine

func fetchMessage() -> AnyPublisher<String, Never> {
    // 단일 값을 방출하는 Just
    Just("Hello, Index!")
    // AnyPublisher로 변환
        .eraseToAnyPublisher()
}

func fetchConditionally(_ condition: Bool) -> AnyPublisher<String, Never> {
    if condition {
        return Just("Condition is true").eraseToAnyPublisher()
    } else {
        return Just("Condition is false").eraseToAnyPublisher()
    }
}

@main
struct Main {
    static func main() {
        var cancellable = fetchMessage()
            .sink { message in
                print(message)
            }
        
        cancellable = fetchConditionally(true)
            .sink { print($0) } // 출력: Condition is true
    }
}
