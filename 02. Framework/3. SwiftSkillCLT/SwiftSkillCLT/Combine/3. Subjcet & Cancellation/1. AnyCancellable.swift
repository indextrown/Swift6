//
//  AnyCancellable.swift.swift
//  SwiftSkillCLT
//
//  Created by 김동현 on 1/13/25.
//

/*
 sink와 assign으로 구독하면 **AnyCancellable**을 반환합니다.
 이 **AnyCancellable**은 Cancellable 프로토콜을 채택하며,
 따라서 cancel() 메서드가 내부적으로 구현되어 구독을 취소할 수 있습니다.
 */
import Combine

@main
struct Main {
    static func main() {
        
        let subject = PassthroughSubject<Int, Never>()
        
        let cancellable = subject.sink { value in
            print("\(value)")
        }
        
        // 구독 취소
        cancellable.cancel()
    }
}

